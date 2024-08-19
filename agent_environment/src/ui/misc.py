from misc import get_atoms, run_clingo

UI_TEMP_FILE = "ui_parse_temp.lp"
def parse_state_actions(s: str): 
    # code to parse the action and hold 
    with open(UI_TEMP_FILE, "w") as f:
        f.write(s)
        f.write("#show hold/3.")
        f.write("#show occur/3.")

    # calcualte the initial state of the agent with its domain and initial state description 
    (run_success, output) = run_clingo([UI_TEMP_FILE])
    if not run_success:
        raise Exception(f"cannot parse for state and actions")
    # parse atoms
    atoms = get_atoms(output)
    #
    state = []
    actions = []
    for atom in atoms:
        atom = atom.strip()
        if atom.startswith("hold"):
            state.append(atom)
            continue

        actions.append(atom)
    
    # convert the state to the right format
    for i in range(len(state)):
        # get the original
        atom = state[i]
        atom = UIFluent(atom)
        # put it back
        state[i] = atom

    # convert the action to the right format 
    for i in range(len(actions)):
        # get the original
        atom = actions[i]
        atom = UIAction(atom)
        # put it back
        actions[i] = atom
    # print("test parse", s, state, action) 
    return state, actions

class UIFluent:
    # expect a single line string
    # that is trim
    # no error checking has been done in this function
    def __init__(self, s) -> None:
        values = s.split(",")
        # first one is "hold("
        # name is from 5 to the first comma 
        self.name = values[0][5:]

        # value is idx+1 + 1 due to "("" until the last comma 
        self.value = ",".join(values[1:-1])

        # agent
        self.agent = None 
        # agent is ( until first comma
        cm1 =   self.value.find(",")
        if cm1 != -1:
            self.agent = self.value[1:cm1]
        self.value = self.value[cm1+1:-1]

        # time is the last comma + 1 until before the closing bracket and the .
        self.time = values[-1][0:-2]


    def __str__(self) -> str:
        return f"fluent: {self.name} -- agent: {self.agent} -- value: {self.value}"

class UIAction:
    # expect a single line string
    # that is trim
    # no error checking has been done in this function
    def __init__(self, s) -> None:
        values = s.split(",")
        # first one is "occur("
        # name is from 6 to the first comma 
        self.name = values[0][6:]

        # value is idx+1 + 1 due to "("" until the last comma 
        self.value = ",".join(values[1:-1])

        # agent
        self.agent = None 
        # agent is ( until first comma
        cm1 =   self.value.find(",")
        if cm1 != -1:
            self.agent = self.value[1:cm1]
        self.value = self.value[cm1+1:-1]

        # time is the last comma + 1 until before the closing bracket and the .
        self.time = values[-1][0:-2]

    def __str__(self) -> str:
        return f"action: {self.name} -- agent: {self.agent} -- value: {self.value}"