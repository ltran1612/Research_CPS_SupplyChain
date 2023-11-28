from threading import Lock 

# manage the global state information 
# thread-safe
class StateManger:
    state = "" 
    states = {} 
    messages = {}
    setup_info = {}
    agents = []

    lock = Lock() 
    def __init__(self, agents):
        self.agents = agents
        for agent in agents:
            self.states[agent] = ""

    # function to receive setup information from the domain
    def setup(self, agent, setup_info):    
        self.lock.acquire()
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
    def calculate_state(self): 
        self.lock.acquire()
        # calculate states - TODO
        self.state = ""
        for agent in self.agents:
            self.states[agent] = ""

        # reset message buffer
        self.messages = {}
        self.lock.release()

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

