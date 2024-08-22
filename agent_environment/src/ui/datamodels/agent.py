from ui.datamodels.base import DataModel

class AgentDataModel(DataModel):
    def __init__(self, s, name):
        super().__init__()
        self.atoms = ""
        self.name = name
        self.action = "" 
        self.load_from_string(s)
        self.plan = ""

    # load the data from a string
    def load_from_string(self, s):
        # split the strings for atoms
        self.atoms = s 
        # reset the action
        self.action = ""
        # update to the subscribers
        self._notify_subscribers(self.name)
    
    # load action
    def load_action(self, action):
        self.action = action
        self._notify_subscribers(self.name)
    
    # load plan
    def load_plan(self, plan):
        # filter out only the occur atoms
        self.plan = plan
        # notify
        self._notify_subscribers(self.name)

    # TODO: get plan, action, and local state
    def get_state(self):
        return self.atoms
    def get_action(self):
        return self.action
    def get_plan(self):
        return self.plan

    def __str__(self):
        res = [""]
        atoms = self.atoms.split(". ")
        atoms = list(set(atoms))
        res.extend(atoms)
        s ="\n**".join(res)
        p = self.plan
        a = self.action 
        return f"Agent: {self.name}{s}\nPlan:\n{p}\nAction:{a}"

    # fill function, to be implemented by child classes
    def fill(self, frame):
        raise NotImplementedError("not implemented")