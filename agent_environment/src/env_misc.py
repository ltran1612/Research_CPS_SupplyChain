from threading import Lock 
from misc import decode_setup_data, run_clingo

# manage the global state information 
# thread-safe
class StateManger:
    global_state = "global_state_temp.lp" 
    messages = {}
    setup_info = {}
    agents = []

    lock = Lock() 
    def __init__(self, agents, config):
        self.global_domain = config["global_domain"]
        self.parsers = config["parsers"]
        self.agents = agents

        # reset the global state to empty
        with open(self.global_state, "w") as f:
            f.write("")

    # function to receive setup information from the domain
    def setup(self, agent, agent_setup_info):    
        self.lock.acquire()
        # decode the setup data retrieved from each agent
        # each data will be a string containing the information
        agent_setup_data = decode_setup_data(agent_setup_info)

        # write the values of each key to a temp file
        for key in agent_setup_data.keys():
            file_name = f"{key}_{agent}_temp.lp"
            with open(file_name, "w") as f:
                f.write(agent_setup_data[key])
            # save the file name instead of a file now
            agent_setup_data[key] = file_name
        
        # set up the data for each agent  
        self.setup_info[agent] = agent_setup_data

        #  add initial state to global state
        # get the initial state
        initial_state = "" 
        with open(agent_setup_data["initial_state"], "r") as f:
            initial_state = "".join(f.readlines()) 

        # MAYBE: parse the initial state to a form used by environment
        # write the initial state to the global state 
        with open(self.global_state, "w+") as f:
            f.write(initial_state)
        
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
    # TODO:
    def calculate_state(self): 
        self.lock.acquire()
        # TODO: move the file from scenarios to a folder meant for environment 
        compute_global_state_code = "../scenarios/builder_lumber/env/compute_next.lp"

        # temp file
        # calculate global state
        # add in messages from each agent
        # the added message needs to be pass
        temp_file = "env_temp.lp"
        if len(self.messages.keys()) > 0: # if there is a message
            with open(temp_file, "w") as f:
                for agent in self.agents:
                    f.write(self.messages[agent]) # write the message to the file
        
        
        # run the program to calcualte the state
        files = [temp_file, self.global_state, compute_global_state_code]
        (run_success, output) = run_clingo(files)
        if run_success:
            print(output)
            # saves the global state
            with open(self.global_state, "w") as f:
                f.write(output)
        
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
        # TODO: get state for each agent from the global state
        # it will be done by doing some parsing. 
        self.lock.release()

        return state

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

