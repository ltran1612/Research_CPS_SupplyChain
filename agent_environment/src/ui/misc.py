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
        if atom.startswith("hold"):
            state.append(atom)
            continue

        actions.append(atom)
    
    # TODO: convert the state to the right format
    # TODO: convert the action to the right format 
    # print("test parse", s, state, action) 
    return state, actions