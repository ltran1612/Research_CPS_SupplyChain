from ui.datamodels.base import DataModel

class AgentDataModel(DataModel):
    def __init__(self, s, name):
        self.atoms = []
        self.name = name
        self.actions = []
        self.load_from_string(s)

    # load the data from a string
    def load_from_string(self, s):
        # split the strings for atoms
        atoms = s.split(". ")
        atoms = list(set(atoms))
        self.atoms = atoms
    
    # load action
    def load_action(self, action):
        self.actions.append(action)
    
    def __str__(self):
        res = [""]
        res.extend(self.atoms)
        s ="\n**".join(res)
        return f"Agent: {self.name}{s}"

    # fill function, to be implemented by child classes
    def fill(self, frame):
        raise NotImplementedError("not implemented")
        