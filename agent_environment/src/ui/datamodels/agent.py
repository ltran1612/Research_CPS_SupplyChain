from ui.datamodels.base import DataModel

class AgentDataModel(DataModel):
    def __init__(self, s, name):
        super().__init__()
        self.atoms = []
        self.name = name
        self.action = "" 
        self.load_from_string(s)
        self.plan = ""

    # load the data from a string
    def load_from_string(self, s):
        # split the strings for atoms
        atoms = s.split(". ")
        atoms = list(set(atoms))
        self.atoms = atoms
        # update to the subscribers
        self._notify_subscribers(self.name)
    
    # load action
    def load_action(self, action):
        self.action = action
        self._notify_subscribers(self.name)

    # load plan
    def load_plan(self, plan):
        self.plan = plan
        # notify
        self._notify_subscribers(self.name)
    
    def __str__(self):
        res = [""]
        res.extend(self.atoms)
        s ="\n**".join(res)
        p = self.plan
        a = self.action 
        return f"Agent: {self.name}{s}\nPlan:\n{p}\nAction:{a}"

    # fill function, to be implemented by child classes
    def fill(self, frame):
        raise NotImplementedError("not implemented")