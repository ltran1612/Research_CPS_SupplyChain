# the state manager for the environment
import traceback
from threading import Lock 
from misc import run_clingo, get_atoms, atoms_to_str
from parser_factory import ParserFactory
import logging
import re
import json

# base class for individual approach for state manager
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

# a thread-safe object to check the number of messages that the user responded.
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

# create a regex for catching the fluent
def create_fluent_regex(fluent):
   return r"h\(" + re.escape(fluent) + r"\(.*\),\d+\)\."
# a prototype for a state manager using a single domain file
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
class StateMangerIndividual(StateManger): 
    agent_state = {}
    # store the global domain that the all agents share.
    # something like the numbers that we can use. 
    global_domain = "global_domain_temp.lp"
    temp_file2 = "env_temp2.lp"
    actions = {}

    def __init__(self, agents, global_domain, actions_success_rules, global_state_rules):
        super().__init__(agents)

        # set up temp file for the state of agents
        for agent in agents:
            self.agent_state[agent] = f"{agent}_state_temp.lp"
        
        # set up temp file for global domain
        with open(global_domain, "r") as f:
            with open(self.global_domain, "w") as f2:
                f2.write("".join(f.readlines()))
        
        # global state rules 
        self.global_state_rules = global_state_rules 
        self.actions_success_rules = actions_success_rules
        self.actions = {}
        for agent in self.agents:
            self.actions[agent] = ""

    # save the setup information for each agent
    def setup(self, agent, agent_setup_info):
        super().setup(agent, agent_setup_info)

        # set upt init
        self.lock.acquire()
        state_filename = self.agent_state[agent]
        with open(state_filename, "w") as f:
            f.write(self.setup_info[agent]["initial_state"])
        self.lock.release()
    
    def __determine_actions_success(self, step):
        logging.info(f"Determine the success of the actions executed at the end of step {step}")
        # reset
        with open(self.temp_file2, "w") as f:
            f.write("")
        # we expect each agent to only send the action that they will execute
        for agent in self.agents:
            # get the message of the agent
            message = self.messages[agent] if agent in self.messages else ""
            self.actions[agent] = message

            # write the action of each agent to a temporary file
            with open(self.temp_file, "w") as f:
                f.write(self.actions[agent])
                f.write(f"agent_env({agent}).")
                f.write("occur_env(Ag, A, T) :- occur(A, T), agent_env(Ag).")
                f.write("hold_env(Ag, A, T) :- hold(A, T), agent_env(Ag).")
                f.write("#show occur_env/3.")
                f.write("#show hold_env/3.")
            
            # run clingo with only temp file
            (run_success, output) = run_clingo([self.temp_file, self.agent_state[agent]])
            if not run_success:
               raise Exception(f"cannot calculate the global actions of {agent} at step {step}")

            with open(self.temp_file2, "a") as f:
                f.write("".join(output))

        # write the global actions to a file 
        with open(self.temp_file, "w") as f:
            f.write("#show occur_env_success/3.")
            f.write(f"current_time_env({step}).")

        files = [self.temp_file, self.temp_file2, self.actions_success_rules]
        (run_success, output) = run_clingo(files)
        if not run_success:
            raise Exception(f"cannot emulate the global actions success at step {step} with error {''.join(output)}")
        succeeded_actions = "".join(output)

        # get the actions that are successful back to each agent
        for agent in self.agents:
            attempted_action = self.actions[agent] 
            if attempted_action == "":
                continue
            with open(self.temp_file, "w") as f:
                f.write(succeeded_actions)
                f.write(f"agent_env({agent}).")
                f.write(f"current_time_env({step}).")
                f.write(f"occur(A, T) :- occur_env_success(Ag, A, T), agent_env(Ag), current_time_env({step}).")
                f.write(f"#show occur/2.")

            files = [self.temp_file]
            (run_success, output) = run_clingo(files)
            if not run_success:
                raise Exception(f"cannot get the succeeded actions for {agent} at step {step} with error {''.join(output)}")

            executed_action = "".join(output)
            answer = input(f"Do not let action {attempted_action} to be executed (yes='y'/no=other answer):")
            if answer == "y":
                executed_action = "" 
            if attempted_action != "":
                result = "but failed"
                if executed_action != "":
                    result = f"the action executed is {executed_action}" 
                if executed_action == attempted_action:
                    result = "and succeeded"
                logging.info(f"{agent} attempted to do {attempted_action} at time {step}, {result}.")
            self.actions[agent] = executed_action

    def __determine_next_state(self, step):
        # while we have not finished with calculating the state of each agent
        while True:
            # compute individual state
            for agent in self.agents:
                # get the message of the agent
                action = self.actions[agent]
                action_temp = self.temp_file
                # write the message to a temporary file
                with open(self.temp_file, "w") as f:
                    f.write(action)
                    f.write("#show hold/2.")
                    f.write("#show occur/2.")

                # get the domain of each agent
                domain_temp = self.temp_file2
                with open(domain_temp, "w") as f:
                    with open(self.setup_info[agent]["domain"], "r") as f2:
                        f.write("".join(f2.readlines()))
                
                # run clingo with the message, domain, global domain, and the previous state 
                files = [action_temp, domain_temp, self.agent_state[agent], self.global_domain]
                (run_success, output) = run_clingo(files)
                # if we succesfully compute the state, save the state to self.agent_state
                if run_success: 
                    with open(self.agent_state[agent], "w") as f:
                        f.write("".join(output))
                else:
                    logging.error(f"cannot calculate the state for {agent} at time {step}")
                    return False

            # number of atoms before and after parsing 
            atoms_num_before = 0

            # convert the individual state of of each agent to global form 
            # initialize the file for the global state
            env_state = "env_global_temp.lp"  
            with open(env_state, "w") as f:
                f.write("")
            # write the global form of the state of each agent
            for agent in self.agents:
                temp_file = self.temp_file
                with open(temp_file, "w") as f:
                    # write the agent of quesetion
                    f.write(f"agent_env({agent}).")
                    # parsing rule to map the individual state to the global state
                    f.write("hold_env(A, F, T) :- hold(F, T), agent_env(A), time(T).")
                    f.write("occur_env(A, B, T) :- occur(B, T), agent_env(A), time(T).")
                    f.write(f"#show hold_env/3.")
                    f.write(f"#show occur_env/3.")

                # map the state with:
                # 1. the global domain
                # 2. the individual state of the agent
                # 3. the temporary file containing the mapping rules
                files = [temp_file, self.agent_state[agent], self.global_domain]
                (run_success, output) = run_clingo(files)
                if run_success: 
                    # if successfull:
                    # 1: save the global state result 
                    with open(env_state, "a") as f:
                        f.write("".join(output))
                    
                    # get the number of atoms in the state
                    atoms = get_atoms(output)
                    atoms_num_before += len(atoms)
                else:
                    logging.error(f"cannot filter the state for only fluents and actions {agent}")
                    return False

            # # DEBUG: see the condition of each state before transitioning 
            # with open(env_state, "r") as f:
            #     logging.info(f"time is {step}")
            #     logging.info("".join(f.readlines()))
            
            # run the parsing rules (mapping rules) 
            temp_file = self.temp_file
            # write the show rules first
            with open(temp_file, "w") as f: 
                f.write("#show hold_env/3.")
                f.write("#show occur_env/3.")
            # write all the parser scripts into one file

            # run the env state with the parser scripts 
            atoms_num_after = 0
            files = [temp_file, env_state, self.global_domain, self.global_state_rules]
            (run_success, output) = run_clingo(files)
            if run_success: 
                # write the new env state
                with open(env_state, "w") as f:
                    f.write("".join(output))

                # get the number of atoms after parsing
                atoms = get_atoms(output)
                atoms_num_after += len(atoms)
            else:
                logging.error(f"there is some conflict between the states of agents")
                return False

            # if the number of atoms before and after parsing is the same, nothing was added, we are done
            if atoms_num_before == atoms_num_after:
                break
            
            # error catching, if the number of atoms before is greater than the number of atoms after, error. 
            if atoms_num_before > atoms_num_after:
                logging.error(f"something is wrong when computing env state, atoms number after checking rules is greater than atoms number before")
                return False

            # here we know that there are more atoms than before. 
            # distill new stuffs back for each agent
            for agent in self.agents:
                # the mapping rules to map back from the environment form to individual form.
                temp_file = self.temp_file
                with open(temp_file, "w") as f:
                    # the agent to distill back
                    f.write(f"agent_env({agent}).")
                    f.write("hold(B, T) :- hold_env(A, B, T), time(T), agent_env(A).")
                    f.write("occur(B, T) :- occur_env(A, B, T), time(T), agent_env(A).")
                    # show only the hold and occur
                    f.write(f"#show hold/2.")
                    f.write(f"#show occur/2.")

                # distill with:
                # 1. the global domain
                # 2. the entire environment state
                # 3. the temporary file containing the mapping rules
                files = [temp_file, env_state, self.global_domain]
                (run_success, output) = run_clingo(files)
                if run_success: 
                    # write the result for each agent
                    with open(self.agent_state[agent], "w") as f:
                        f.write("".join(output))
                    
                    # # DEBUG: see the condition of each agent after distilling 
                    # with open(self.agent_state[agent], "r") as f:
                    #     logging.info(f"time is {step} for agent {agent}")
                    #     logging.info("".join(f.readlines()))
                else:
                    logging.error(f"cannot distill from env state to individual state")
                    return False

        # reset message buffer
        self.messages = {}
        
    # calculate the state for the entire environment
    def calculate_state(self, step=None):
        if step is None:
            return False

        self.lock.acquire()
        # write the next step to the global domain 
        with open(self.global_domain, "a") as f:
            f.write(f"time({step}).")

        try:
            # determine the success of the actions of each agent
            if step > 0:
                self.__determine_actions_success(step-1)

            # gotten the actions, determine the next state
            self.__determine_next_state(step) 
            return True
        except Exception as e:
            logging.error(e.__str__())
            traceback.print_exc()
            return False
        finally:
            self.lock.release()

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

# encode the setup data to a JSON string to send 
# precondition: the config object 
def encode_setup_data(config) -> dict:
    domain = config["domain"]
    initial_state = config['initial_state']
    interested_atoms = config["interest"]

    setup_data = {} 
    with open(domain, "r") as f:
        setup_data["domain"] = "".join(f.readlines())
    with open(initial_state, "r") as f:
        setup_data["initial_state"] = "".join(f.readlines())
    setup_data["interest"] = interested_atoms 

    return json.dumps(setup_data)

# decode the setup data to an object from the JSON string
# precondition: the JSON string as input
def decode_setup_data(config):
    result = json.loads(config)
    for key in result.keys():
        if type(result[key]) is str:
            result[key] = "".join(result[key])

    return result