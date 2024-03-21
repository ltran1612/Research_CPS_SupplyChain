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
        domain_filename = f"{agent}_domain_env_temp.lp"
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

# a different version of state manager
# we will compute the state for each agent individually
class StateMangerIndividual(StateManger): 
    agent_state = {}
    # store the global domain that the all agents share.
    # something like the numbers that we can use. 
    global_domain = "global_domain_env_temp.lp"
    env_state = "env_global_env_temp.lp"  
    old_env_state = "old_env_global_env_temp.lp"  
    temp_file2 = "env_temp2.lp"
    actions = {}

    def __init__(self, agents, global_domain, actions_success_rules, global_state_rules):
        super().__init__(agents)

        # set up temp file for the state of agents
        for agent in agents:
            self.agent_state[agent] = f"{agent}_state_env_temp.lp"
        
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
        with open(self.old_env_state, "w") as f:
            f.write("")
        with open(self.env_state, "w") as f:
            f.write("")

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
                f.write(f"current_env_time({step}).")
                f.write("occur_env(Ag, A, T) :- occur(A, T), agent_env(Ag), not current_env_time(T).")
                f.write("occur_env_attempt(Ag, A, T) :- occur(A, T), agent_env(Ag), current_env_time(T).")
                f.write("hold_env(Ag, A, T) :- hold(A, T), agent_env(Ag).")
                f.write("#show occur_env/3.")
                f.write("#show occur_env_attempt/3.")
                f.write("#show hold_env/3.")
            
            # run clingo with only temp file
            (run_success, output) = run_clingo([self.temp_file, self.agent_state[agent]])
            if not run_success:
               raise Exception(f"cannot calculate the global actions of {agent} at step {step}")

            with open(self.temp_file2, "a") as f:
                f.write("".join(output))

        # write the global actions to a file 
        with open(self.temp_file, "w") as f:
            f.write("#show occur_env_attempt_success/3.")
            f.write(f"current_env_time({step}).")

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
                f.write(f"current_env_time({step}).")
                f.write(f"occur(A, T) :- occur_env_attempt_success(Ag, A, T), agent_env(Ag), current_env_time({step}).")
                f.write(f"#show occur/2.")

            files = [self.temp_file]
            (run_success, output) = run_clingo(files)
            if not run_success:
                raise Exception(f"cannot get the succeeded actions for {agent} at step {step} with error {''.join(output)}")

            executed_action = "".join(output)
            answer = input(f"Allow the action {attempted_action} to be executed fully (yes='y'/no='n'/decide with the specified rules=other answers):")
            if attempted_action != "":
                result = "but failed"
                if answer == "y":
                    executed_action = attempted_action 
                elif answer == "n": 
                    executed_action = "" 

                if executed_action != "":
                    result = f"the action executed is {executed_action}" 
                if executed_action == attempted_action:
                    result = "and succeeded"
                logging.info(f"{agent} attempted to do {attempted_action} at time {step}, {result}.")
            self.actions[agent] = executed_action

    def __determine_next_state(self, step):
        # while we have not finished with calculating the state of each agent
        while True:
            # COMPUTE INDIVIDUAL STATE AND BUILD THE THE GLOBAL STATE FORM
            # compute individual state
            # convert the individual state to the global state
            for agent in self.agents:
                # get the message of the agent
                action = self.actions[agent]
                # write the message to a temporary file
                with open(self.temp_file, "w") as f:
                    f.write(action)
                    # write the agent of quesetion
                    f.write(f"agent_env({agent}).")
                    # write the current time step
                    f.write(f"current_env_time({step}).")
                    # parsing rule to map the individual state to the global state
                    # the new hold fluent at current time step will be subject to decision
                    f.write("hold_env_attempt(A, F, T) :- hold(F, T), agent_env(A), time(T), current_env_time(T).")
                    # map the actions that occured in the previous step
                    f.write("occur_env(A, B, T-1) :- occur(B, T-1), agent_env(A), time(T-1), current_env_time(T).")
                    # show only the hold_env_attempt and occur_env
                    f.write(f"#show hold_env_attempt/3.")
                    f.write(f"#show occur_env/3.")

                # get the domain of each agent
                domain_file = self.setup_info[agent]["domain"]
                # run clingo with the message, domain, global domain, and the previous state 
                files = [self.temp_file, domain_file, self.agent_state[agent], self.global_domain]
                # determine the success of running
                (run_success, output) = run_clingo(files)
                # if we succesfully compute the state, save the state to self.agent_state
                if not run_success: 
                    raise Exception(f"cannot calculate the state for {agent} at time {step} with error {''.join(output)}")
                
                # convert the successful attempted actions in previous iteration (if any) back to hold_env
                with open(self.temp_file, "w") as f:
                    f.write("".join(output))
                    f.write("hold_env(A, F, T) :- hold_env_attempt(A, F, T), hold(F, T).")
                files = [self.temp_file, self.agent_state[agent]]         
                (run_success, output) = run_clingo(files)
                if not run_success:
                    raise Exception(f"cannot map the successful attempted actions in previous steps to still be successful") 

                # append the state to the env state
                with open(self.env_state, "a") as f:
                    f.write("".join(output))

            # RUN THE ENV STATE WITH THE PARSER SCRIPTS 
            # rules to parse just the right output
            with open(self.temp_file, "w") as f: 
                f.write(f"current_env_time({step}).")
                f.write("#show hold_env/3.")
                f.write("#show occur_env/3.")

            files = [self.temp_file, self.env_state, self.global_domain, self.global_state_rules]
            (run_success, output) = run_clingo(files)
            if not run_success: 
                raise Exception(f"there is some conflict between the states of agents at time {step} with error {''.join(output)}")
            # write the new state to self.env_state file
            with open(self.env_state, "w") as f:
                f.write("".join(output))

            # here we know that there are more atoms than before. 
            # distill new stuffs back for each agent
            for agent in self.agents:
                # the mapping rules to map back from the environment form to individual form.
                with open(self.temp_file, "w") as f:
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
                files = [self.temp_file, self.env_state, self.global_domain]
                (run_success, output) = run_clingo(files)
                if not run_success: 
                    raise Exception(f"cannot distill from env state to individual state")

                # write the result for each agent
                with open(self.agent_state[agent], "w") as f:
                    f.write("".join(output))
                
            # check if the same or difference
            # get old state
            old_state = []
            with open(self.old_env_state, "r") as f:
                old_state = f.readlines();
            old_atoms = get_atoms(old_state)
            # check the old and new state together
            (run_success, output) = run_clingo([self.old_env_state, self.env_state])
            if not run_success:
                raise Exception(f"cannot compare the state at time {step} with error {''.join(output)}")
            old_new_atoms = get_atoms(output)
            # the new state becomes the old state
            with open(self.old_env_state, "w") as f:
                with open(self.env_state, "r") as f2:
                    f.write("".join(f2.readline()))
            if len(old_new_atoms) == len(old_atoms):
                break
        # reset message buffer
        self.messages = {}
        
    # calculate the state for the entire environment
    def calculate_state(self, step=None):
        if step is None:
            return False

        self.lock.acquire()
        # write the next step to the global domain 
        with open(self.global_domain, "a") as f:
            f.write(f"\ntime({step}).\n")

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