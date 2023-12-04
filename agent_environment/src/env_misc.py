from threading import Lock 
from misc import decode_setup_data, run_clingo, get_atoms, atoms_to_str
import re

# manage the global state information 
# thread-safe
class StateManger:
    global_state = "global_state_temp.lp" 
    messages = {}
    setup_info = {}
    agents = []
    temp_file = "env_temp.lp"

    lock = Lock() 
    def __init__(self, agents, config):
        self.parsers = config["parsers"]
        self.agents = agents

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

    # function to receive setup information from the domain
    def setup(self, agent, agent_setup_info):    
        self.lock.acquire()
        # decode the setup data retrieved from each agent
        # each data will be a string containing the information
        agent_setup_data = decode_setup_data(agent_setup_info)
        
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

    # calculate state
    def calculate_state(self, step=None): 
        self.lock.acquire()
        # MAYBE: move the file from scenarios to a folder meant for environment 
        compute_global_state_code = "../scenarios/builder_lumber/env/compute_next.lp"

        # temp file
        # calculate global state
        # add in messages from each agent
        # the added message needs to be pass
        messages = self.temp_file
        if len(self.messages.keys()) > 0: # if there is a message
            with open(messages, "w") as f:
                # write the step
                if not step is None:
                    f.write(f"step({step}).")
                for agent in self.agents:
                    f.write(self.messages[agent]) # write the message to the file
        
        
        # run the program to calcualte the state
        files = [messages, self.global_state, self.domain]
        (run_success, output) = run_clingo(files)
        if run_success:
            # saves the global state
            with open(self.global_state, "w") as f:
                f.write("".join(output))
        
        # reset message buffer
        self.messages = {}
        self.lock.release()

        return run_success 

    # check if setup
    def is_setup(self) -> bool:
        result: bool = False

        self.lock.acquire()
        result = len(self.setup_info) == len(self.agents)
        self.lock.release()

        return result

    # function to get the state relates to an agent 
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

def create_fluent_regex(fluent):
   return r"h\(" + re.escape(fluent) + r"\(.*\),\d+\)\."