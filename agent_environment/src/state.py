class StateManger:
    states = {}
    def __init__(self, agents):
        for agent in agents:
            self.states[agent] = ""
    
    def get_state(self, agent):
        return self.states[agent]
    
    def add_to_state(self, agent, message):
        self.states[agent] += " " + message 