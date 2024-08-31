from misc import get_atoms, run_clingo

# TODO: to be removed
import json
CONFIG = "../config/oec-ver3/ui.json"
#
TEMPLATES = None
with open(CONFIG, "r") as f:
    TEMPLATES = json.loads("".join(f.readlines()))

UI_TEMP_FILE = "ui_parse_temp.lp"
def parse_state_actions(s: str, displayTime=False, templates=TEMPLATES): 
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
        atom = UIFluent(atom, templates=templates["fluents"])
        # put it back
        state[i] = atom

    # convert the action to the right format 
    for i in range(len(actions)):
        # get the original
        atom = actions[i]
        atom = UIAction(atom, displayTime)
        # put it back
        actions[i] = atom
    # print("test parse", s, state, action) 
    return state, actions

class UIFluent:
    # expect a single line string
    # that is trim
    # no error checking has been done in this function
    def __init__(self, s, templates=None) -> None:
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

        # template
        self.template = None
        if templates is not None:
            self.template = "" 
            for template in templates:
                if template == self.name:
                    self.template = templates[template]
                    break
        
    def __replace(self, s:str, target:str, value):
        return s.replace(f"ui#{target}#ui", str(value))

    def __str__(self) -> str:
        if self.template is None:
            if self.agent is not None:
                return f"agent {self.agent} has state '{self.name}' with value '{self.value}'"
            return f"environment has state '{self.name}' with value '{self.value}'"

        if self.template == "":
            return ""

        s: str = self.template    
        if self.agent is not None:
            s = self.__replace(s, "agent", self.agent)

        # parse the values 
        # remove parenthesis
        values = self.value[1:-1]
        values = values.split(",")
        for idx, value in enumerate(values):
            value = value.strip()
            value = value.strip(".()")
            if value == "":
                continue
            s = self.__replace(s, idx+1, value)
        return s


class UIAction:
    # expect a single line string
    # that is trim
    # no error checking has been done in this function
    def __init__(self, s, displayTime=False) -> None:
        # flag to display time or not 
        self.displayTime = displayTime 

        # 
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
        time_str = ""
        if self.displayTime:
            time_str = f" at time {self.time}" 
        return f"agent {self.agent} do '{self.name}' with value '{self.value}'{time_str}"