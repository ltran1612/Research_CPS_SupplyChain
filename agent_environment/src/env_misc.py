# the state manager for the environment
import traceback
from threading import Lock 
from misc import copy_file, reset_file, run_clingo, get_atoms, atoms_to_str
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
        
        # put contracts to a file
        contracts_filename = f"{agent}_contract_env_temp.lp"
        with open(contracts_filename, "w") as f:
            f.write(agent_setup_data['contracts']) 
            agent_setup_data['contracts'] = contracts_filename
        
        # put clause concerns to a file
        clause_concern_mapping_filename = f"{agent}_clause_concern_mapping_env_temp.lp"
        with open(clause_concern_mapping_filename, "w") as f:
            f.write(agent_setup_data['clause_concern_map']) 
            agent_setup_data['clause_concern_map'] = clause_concern_mapping_filename
        
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

# the global version of state manager
class StateMangerGlobal(StateManger): 
    # store the global domain that the all agents share.
    # something like the numbers that we can use. 
    global_domain = "global_domain_env_temp.lp"
    env_state = "state_env_temp.lp"  
    env_state_history = "state_env_history_temp.lp"  
    temp_file2 = "env_temp2.lp"
    state_calculator = "state_calculator_env_temp.lp"
    cps_reasoner = "cps_reasoner_env_temp.lp"
    global_config = "global_config_env_temp.lp"
    ontologies = []
    actions = {}
    lastStep = 0

    def __init__(self, agents, global_domain, global_config, state_calculator, cps_reasoner, ontologies):
        super().__init__(agents)

        # set up temp file for global domain
        copy_file(global_domain, self.global_domain)
        # initialize the global state to empty
        reset_file(self.env_state)
        # reset history
        reset_file(self.env_state_history)
        # global state rules 
        self.actions = {}
        for agent in self.agents:
            self.actions[agent] = ""
        # global config 
        copy_file(global_config, self.global_config)
        # state_calculator 
        copy_file(state_calculator, self.state_calculator)
        # cps reasoner
        copy_file(cps_reasoner, self.cps_reasoner)
        # clause concern map
        copy_file(cps_reasoner, self.cps_reasoner)
        # ontologies
        for num, ontology in enumerate(ontologies):
            ontology_temp = f"ontology_{num}_env_temp.owl"
            copy_file(ontology, ontology_temp)
            self.ontologies.append(ontology_temp)

        # calcualte
        with open(self.temp_file, "w") as f:
            f.write("#show lastTimeStep/1.")
            f.write(":- lastTimeStep(T), not T >= 0.")
            f.write(":- lastTimeStep(T), lastTimeStep(T1), not T=T1.")
        (run_success, output) = run_clingo([self.global_config, self.temp_file])
        if not run_success:
            raise Exception("cannot get the last time step")
        
        temp = "".join(output).strip()
        temp = re.findall(r"\d+", temp)
        self.lastStep = int(temp[0])

    def get_last_step(self):
        return self.lastStep

    def __get_filter(self, step=None, agent=None):
        hold_time = "T"
        occur_time = "T"
        action_value = "V"
        if step is not None:
            hold_time = str(step)
            occur_time = str(step-1)
        
        extension = ""
        if agent is not None:
            extension = f"""
            #show hold(F, (EAgent, Value), {hold_time}) : hold(F, (EAgent, Value), {hold_time}), needs({agent}, F, EAgent), type(F, agent).
            #show hold(F, Value, {hold_time}) : needs(F), hold(F, Value, {hold_time}).
            """
            action_value = f"({agent}, V)"
        return f"""#show.
        #show hold(F, ({agent}, V), {hold_time}) : hold(F, ({agent}, V), {hold_time}).
        #show occur(A, {action_value}, {occur_time}) : occur(A, {action_value}, {occur_time}), not failed(A, {action_value}, {occur_time}). 
        {extension}
        """

    # save the setup information for each agent
    def setup(self, agent, agent_setup_info):
        super().setup(agent, agent_setup_info)

        self.lock.acquire()
        # write the initial state description to a temp file
        with open(self.temp_file, "w") as f:
            f.write(self.setup_info[agent]["initial_state"])
            f.write(self.__get_filter())
        # calcualte the initial state of the agent with its domain and initial state description 
        (run_success, output) = run_clingo([self.temp_file, self.setup_info[agent]["domain"]])
        if not run_success:
            raise Exception(f"cannot get the initial state fluents and actions {agent}")
        # write initial state of the agent to the env state.
        with open(self.env_state, "a") as f:
            f.write("".join(output))
        self.lock.release()
    
    def __determine_actions_success(self, step):
        logging.info(f"Determine the success of the actions executed at the end of step {step}")
        # we expect each agent to only send the action that they will execute
        for agent in self.agents:
            # get the message of the agent
            message = self.messages[agent] if agent in self.messages else ""
            message = message.strip()
            self.actions[agent] = message
            answer = "n"
            if message != "": 
                answer = input(f"Allow the action {message} to be executed fully (yes='y'/no='n'):")
            if answer == "n": 
                self.actions[agent] = "" 
    #
    def __update_env_state(self, new_state):
        with open(self.env_state, "w") as f:
            f.write(new_state)  
        with open(self.env_state_history, "a") as f:
            f.write(new_state)
    # get domains
    def __get_domains(self):
        domains = list(map(lambda agent: self.setup_info[agent]["domain"], self.agents))
        return domains
    # get contracts 
    def __get_contracts(self):
        contracts = list(map(lambda agent: self.setup_info[agent]["contracts"], self.agents))
        return contracts 
    # get clause concern mappings 
    def __get_mappings(self):
        mappings = list(map(lambda agent: self.setup_info[agent]["clause_concern_map"], self.agents))
        return mappings 
    #
    def __determine_next_state(self, step):
        # get the domains of each agent
        domains = self.__get_domains()
        # put the actions of each agent to a temp file
        actions_file = self.temp_file
        with open(actions_file, "w") as f:
            for agent in self.agents:
                f.write(self.actions[agent])
            f.write(self.__get_filter(step))
        # calculate the next state
        files = domains
        files.extend([actions_file, self.env_state, self.global_domain, self.global_config, self.state_calculator])
        # 
        (run_success, output) = run_clingo(files)
        if not run_success:
            raise Exception(f"cannot calculate the next state for the environment")
        # write the next state to the env state
        self.__update_env_state("".join(output))
        # reset message buffer
        self.messages = {}
        
    # calculate the state for the entire environment
    def calculate_state(self, step=None):
        if step is None:
            return False

        self.lock.acquire()
        # write the next step to the global domain 
        with open(self.global_config, "a") as f:
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
   
    def get_state(self, agent, step=None):
        self.lock.acquire()

        # get the state of the agent
        agent_state = ""  
        with open(self.temp_file, "w") as f:
            f.write(self.__get_filter(step=step, agent=agent))
        files = [self.temp_file, self.env_state, self.setup_info[agent]["domain"], self.global_config, self.global_domain]
        (run_success, output) = run_clingo(files)
        if not run_success: 
            raise Exception(f"cannot get the state for the agent {agent}")
        
        agent_state = "".join(output)
        self.lock.release()

        return agent_state 

    def display_sat_concerns(self):
        with open(self.temp_file, "w") as f:
            f.write("#show yes_concern(A) : h(sat(A), T), step(T), addressedBy(A, P), property(P).")
            f.write("#show no_concern(A) : -h(sat(A), T), step(T), addressedBy(A, P), property(P).")
            f.write("#show yes_property(A) : h(A, T), step(T),  property(A).")
            f.write("#show no_property(A) : -h(A, T), step(T), property(A).")
            f.write("#show yes_clause(A) : h(sat(A), T), step(T), clause(A).")
            f.write("#show no_clause(A) : not h(sat(A), _), clause(A).")
            f.write("#show.")
            f.write("time(T) :- hold(_, _, T).")

        files = [self.global_config, self.global_domain,\
                self.temp_file, self.env_state_history,\
                self.cps_reasoner]  
        # contracts
        files.extend(self.__get_contracts())
        # clause concern mappings
        files.extend(self.__get_mappings())
        # include ontologies
        files.extend(self.ontologies)
        # include domains
        files.extend(self.__get_domains())
        # run the program
        (run_success, output) = run_clingo(files)
        if run_success:
            atoms = get_atoms(output)
            atoms = list(map(lambda atom :\
                atom.replace("(", " ").replace(")", " ").replace(".", "")\
                ,atoms))
            return "\n".join(atoms)
        else:
            logging.error(f"failed to get state of satisfaction of concerns- {output}")
            raise RuntimeError("failed to get state of satisfaction of concerns")

# encode the setup data to a JSON string to send 
# precondition: the config object 
def encode_setup_data(config) -> dict:
    domain = config["domain"]
    initial_state = config['initial_state']
    contracts = config['contracts']
    clause_concern_map = config['clause_concern_map'] 

    setup_data = {} 
    with open(domain, "r") as f:
        setup_data["domain"] = "".join(f.readlines())
    with open(initial_state, "r") as f:
        setup_data["initial_state"] = "".join(f.readlines())
    with open(clause_concern_map, "r") as f:
        setup_data["clause_concern_map"] = "".join(f.readlines())
    # contracts
    contracts_content = []
    for contract in contracts:
        with open(contract, "r") as f:
            contracts_content.append("".join(f.readlines()))
    setup_data["contracts"] = "".join(contracts_content)


    return json.dumps(setup_data)

# decode the setup data to an object from the JSON string
# precondition: the JSON string as input
def decode_setup_data(config):
    result = json.loads(config)
    for key in result.keys():
        if type(result[key]) is str:
            result[key] = "".join(result[key])

    return result