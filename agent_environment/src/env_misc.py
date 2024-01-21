from threading import Lock 
from misc import decode_setup_data, run_clingo, get_atoms, atoms_to_str
from parser_factory import ParserFactory
import logging
import re

# manage the global state information 
# thread-safe
class StateManger:
    messages = {}
    setup_info = {}
    agents = []
    temp_file = "env_temp.lp"

    lock = Lock() 
    def __init__(self, agents):
        self.agents = agents

    # function to receive setup information from the domain
    def setup(self, agent, agent_setup_info):    
        self.lock.acquire()
        # decode the setup data retrieved from each agent
        # each data will be a string containing the information
        agent_setup_data = decode_setup_data(agent_setup_info)

        # put the domain
        domain_filename = f"{agent}_domain_temp.lp"
        with open(domain_filename, "w") as f:
            f.write(agent_setup_data["domain"])
            agent_setup_data["domain"] = domain_filename
        
        # set up the data for each agent  
        self.setup_info[agent] = agent_setup_data
        self.lock.release()

    # function to receive the message 
    def receive_message(self, agent, message):
        self.lock.acquire()
        # TODO: parse the message to a form that the environment uses

        # store the message
        self.messages[agent] = message
        self.lock.release()

    # function to check if all agent sent the messages
    def received_all(self) -> bool:
        result: bool = False

        self.lock.acquire()
        result = len(self.messages) == len(self.agents)
        self.lock.release()

        return result

    # check if setup
    def is_setup(self) -> bool:
        result: bool = False

        self.lock.acquire()
        result = len(self.setup_info) == len(self.agents)
        self.lock.release()

        return result

    # calculate state
    # Implement this function in the child class
    def calculate_state(self, step=None): 
        pass

    # function to get the state relates to an agent 
    # Implement this function in the child class
    def get_state(self, agent):
        pass

# a thread-safe way to check the number of messages that the user responded.
class Received:
    received = {}
    receiveLock = Lock()

    def __init__(self, agents):
        self.agents = agents
    
    def received_all(self) -> bool:
        result: bool = False

        self.receiveLock.acquire()
        result = len(self.received.keys()) == len(self.agents) 
        self.receiveLock.release()

        return result
        
    def receive(self, agent):
        self.receiveLock.acquire()
        self.received[agent] = None
        self.receiveLock.release()

    def reset(self):
        self.receiveLock.acquire()
        self.received = {}
        self.receiveLock.release()

    def is_in(self, agent):
        result: bool = False

        self.receiveLock.acquire()
        result = agent in self.received.keys()
        self.receiveLock.release()

        return result

class StateManagerGlobal(StateManger):
    global_state = "global_state_temp.lp" 

    def __init__(self, agents, config, global_domain):
        super().__init__(agents)
        self.parsers = config["parsers"]
        self.global_domain = global_domain

        # reset the global state to empty
        one_init = "../scenarios/builder_lumber/one_init.lp"
        with open(one_init, "r") as f: 
            one_init = "".join(f.readlines())
        with open(self.global_state, "w") as f:
            f.write(one_init)

        # update the global domain with the one 
        # TODO: update this to config file
        one_domain = "../scenarios/builder_lumber/one_domain.lp"
        self.domain = one_domain
    
    def setup(self, agent, agent_setup_info):
        self.lock.acquire()
        # decode the setup data retrieved from each agent
        # each data will be a string containing the information
        agent_setup_data = decode_setup_data(agent_setup_info)

        # put the domain
        domain_filename = f"{agent}_domain_temp.lp"
        with open(domain_filename, "w") as f:
            f.write(agent_setup_data["domain"])
            agent_setup_data["domain"] = domain_filename

        # get fluents and atoms
        (result, lines) = run_clingo([agent_setup_data["domain"], self.global_domain])
        if not result:
            logging.error(f"cannot get fluents of {agent}")
            exit(1)
        atoms = get_atoms(lines) 
        parser_factory = ParserFactory()
        fluent_parser = parser_factory.fluent()

        # get fluents
        fluent_atoms = list(filter(parser_factory.is_fluent, atoms))
        fluents = {} 
        for atom in fluent_atoms:
            (fluent, param_num) = fluent_parser(atom)
            if fluent in fluents:
                continue
                
            fluents[fluent] = param_num

        agent_setup_data["interest"].extend(fluents.keys())
        agent_setup_data["interest"] = list(dict.fromkeys(agent_setup_data["interest"]).keys())

        # set up the data for each agent  
        self.setup_info[agent] = agent_setup_data
        self.lock.release()
    
    def calculate_state(self, step=None):
        self.lock.acquire()
        # MAYBE: move the file from scenarios to a folder meant for environment 
        compute_global_state_code = "../scenarios/builder_lumber/env/compute_next.lp"

        # temp file
        # calculate global state
        # add in messages from each agent
        # the added message needs to be pass
        messages = self.temp_file
        with open(messages, "w") as f:
            # write the step
            if not step is None:
                f.write(f"step({step}).")
            if len(self.messages.keys()) > 0: # if there is a message
                for agent in self.agents:
                    f.write(self.messages[agent]) # write the message to the file
        
        
        # run the program to calcualte the state
        files = [messages, self.global_state, self.domain, self.global_domain]
        (run_success, output) = run_clingo(files)
        if run_success:
            # saves the global state
            with open(self.global_state, "w") as f:
                f.write("".join(output))
        
        # reset message buffer
        self.messages = {}
        self.lock.release()

        return run_success 
    
    def get_state(self, agent):
        state = None

        self.lock.acquire()
        interested_fluents = self.setup_info[agent]["interest"]
        state = ""
        with open(self.global_state, "r") as f:
            state = f.readlines()

        state_atoms = get_atoms(state)
        def filter_fluent(x: str):
            for fluent in interested_fluents:
                regex = create_fluent_regex(fluent)
                if re.match(regex, x, re.IGNORECASE):
                    return True

            return False

        agent_interested_info = list(filter(filter_fluent, state_atoms))

        # TODO: get state for each agent from the global state
        # it will be done by doing some parsing. 
        self.lock.release()

        return atoms_to_str(agent_interested_info) 
    
# a different version of state manager
# we will compute the state for each agent individually
# Problems:
# 1) How to maps related fluents of different agents?: Write a script that maps the fluents of one to the other. For example, delivery:
#   - delivery(1000, 1) -> delivery(1000, 1)
# 2) How to have certain global fluents?: Treat the env as an agent. Copies the fluents of this "env agent" to each agent. This special env agent has to be executed first along with the messages from each agent.    
# 4) How to maintain certain global constraints: Have a script that checks for that. Similar to 2. If it is unsatisfiable, then we need to make a decision:
#    a) The actions are not executed: meaning we do not return occur(...) to the corresponding agent.  
#    b) Choose only one action to execute. 
# 3) Handle external actions that interact with the environment. 
class StateMangerIndividual(StateManger): 
    agent_state = {}

    def __init__(self, agents, global_domain):
        super().__init__(agents)

        # set up temp file for the state of agents
        for agent in agents:
            self.agent_state[agent] = f"{agent}_state_temp.lp"
        
        # set up temp file for global domain
        self.global_domain = "global_domain_temp.lp"
        with open(global_domain, "r") as f:
            with open(self.global_domain, "w") as f2:
                f2.write("".join(f.readlines()))
    
    def setup(self, agent, agent_setup_info):
        super().setup(agent, agent_setup_info)

        # set upt init
        self.lock.acquire()
        state_filename = self.agent_state[agent]
        with open(state_filename, "w") as f:
            f.write(self.setup_info[agent]["initial_state"])
        self.lock.release()

    def calculate_state(self, step=None):
        self.lock.acquire()
        for agent in self.agents:
            message = self.messages[agent] if agent in self.messages else ""

            # write the message
            message_temp = self.temp_file
            with open(message_temp, "w") as f:
                if not step is None:
                    f.write(f"time({step}).")
                f.write(message)

            # get the domain of each agent
            domain_temp = "domain_temp.lp"
            with open(domain_temp, "w") as f:
                with open(self.setup_info[agent]["domain"], "r") as f2:
                    f.write("".join(f2.readlines()))
            
            # run clingo with the message, domain, and the state 
            files = [message_temp, domain_temp, self.agent_state[agent], self.global_domain]
            (run_success, output) = run_clingo(files)
            if run_success: 
                # write the result
                with open(self.agent_state[agent], "w") as f:
                    f.write("".join(output))
                # TODO: run parsing to map atoms from one to another and apply constraints between atoms among agents. 
            else:
                logging.error(f"cannot calculate the state for {agent}")
                return False
        
        # reset message buffer
        self.messages = {}
        self.lock.release()

        return True

    def get_state(self, agent):
        self.lock.acquire()

        # get the state of the agent
        agent_state = None
        # agent_state_file = self.agent_state[agent]

        temp_file = self.temp_file
        with open(temp_file, "w") as f:
            f.write(f"#show hold/2.")
            f.write(f"#show occur/2.")

        files = [temp_file, self.agent_state[agent]]
        (run_success, output) = run_clingo(files)
        if run_success: 
            agent_state = "".join(output)
        else:
            logging.error(f"cannot filter the state for only fluents and actions {agent}")
            return False

        self.lock.release()

        return agent_state 

# create a regex for catching the fluent
def create_fluent_regex(fluent):
   return r"h\(" + re.escape(fluent) + r"\(.*\),\d+\)\."