from threading import Lock 
from misc import decode_setup_data, run_clingo

# manage the global state information 
# thread-safe
class StateManger:
    global_state = "" 
    states = {} 
    messages = {}
    setup_info = {}
    agents = []

    lock = Lock() 
    def __init__(self, agents, config):
        self.global_domain = config["global_domain"]
        self.parsers = config["parsers"]
        self.agents = agents
        for agent in agents:
            self.states[agent] = ""

    # function to receive setup information from the domain
    def setup(self, agent, agent_setup_info):    
        self.lock.acquire()
        agent_setup_data = decode_setup_data(agent_setup_info)
        for key in agent_setup_data.keys():
            file_name = f"state_{key}_{agent}_temp.lp"
            with open(file_name, "w") as f:
                f.write(agent_setup_data[key])
            agent_setup_data[key] = file_name
        
        self.setup_info[agent] = agent_setup_data
        self.lock.release()

    # function to receive the message 
    def receive_message(self, agent, message):
        self.lock.acquire()
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
        temp_file = "state_temp.lp"
        if len(self.messages.keys()) != 0:
            with open(temp_file, "w") as f:
                for agent in self.agents:
                    f.write(self.messages[agent])
        

        files = [temp_file, self.global_domain] 
        for agent in self.agents:
            agent_data = self.setup_info[agent]
            files.append(agent_data["domain"])
            files.append(agent_data["initial_state"])
        (result, lines) = run_clingo(files)
        # todo: handle error
        if not result:
            return False

        self.global_state = "".join(lines)
        with open(temp_file, "w") as f:
            f.write(self.global_state)

        # calculate states
        for agent in self.agents:
            files = [self.parsers[agent], temp_file]
            (result, lines) = run_clingo(files)
            
            # todo: handle error
            if not result:
                return False

            self.states[agent] = "".join(lines)
            print(agent, self.states[agent])
        # reset message buffer
        self.messages = {}
        self.lock.release()

    # check if setup
    # TODO: make sure that the setup information is scalable
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
        state = self.states[agent]
        self.lock.release()

        return state

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

