import sys, subprocess
import json
import logging

# the default config
defaultConfig = {
    "brokerAddress": "mqtt://localhost:1883",
} # 
# a function to display the content of config file 
def show_config(config):
    address = config["brokerAddress"]
    id = False 
    try:
        id = config["id"]
    except Exception as e:
        pass
    
    print(f"MQTT Broker address is {address}")
    if id:
        print(f"This is an Agent with id {id}")
    else: 
        parsers = config["parsers"]
        print(f"This is an Environment with these pairs set up: {json.dumps(parsers)}")

# a function to load the config from the command line arguments
def load_config():
    args = sys.argv
    if len(args) > 1:
        config_path = args[1]
        text = ""
        with open(config_path, "r") as file:
            text = file.readlines()
            text = "".join(text)
        config = json.loads(text)
        return config

    return defaultConfig

# run clingo raw and just returns the subprocess result output
def run_clingo_raw(files: list, flags=["-V0", "--out-atom=%s."]):
    command = ["clingo"]
    command.extend(files)
    command.extend(flags)
    result= subprocess.run(command, capture_output=True)
    return result

# run clingo and return 
# 1) True if Clingo found an answer set. 
# 2) False if unsatisfiable. 
# The boolean result is return in a tuple along with a list of line in the output of Clingo
def run_clingo(files: list, flags=["-V0", "--out-atom=%s."]):
    result = run_clingo_raw(files, flags)
    # parse the message
    parsed_message: str = result.stdout.decode("utf-8")
    # clean the message
    parsed_message = parsed_message.strip()
    # parse the lines
    lines = parsed_message.split("\n")
    status = lines.pop(-1)
    if "UNSATISFIABLE" == status: 
        return (False, lines)

    return (True, lines)

# parse the output of running clingo on subprocess to get the list of atoms in the answer set 
# precondition: we would expect that the output comes from running clingo with the flags -V0 --output-atoms=%s.
def parse_clingo_output(output: str): 
    output = output.strip()
    lines = output.split("\n")
    lines.pop(-1)

    return get_atoms(lines)

# get only the atoms out of all of the lines
# precondition: a list of lines from the output of Clingo
# each atom must end with a dot: "."
def get_atoms(lines: list[str]):
    result = [] 
    for line in lines:
        result.extend(line.split("."))
    
    def clean(item):
        item = item.strip()
        if item != "":
            item += "."
        return item
    result = list(map(clean, result))
    if len(result) > 1:
        result.pop(-1)
    return result 

# convert a list of atoms to string separted by spaces
def atoms_to_str(lines: list[str]):
    return " ".join(lines)

# write to a temporary file by rewriting the content of the file with new one.  
def write_to_temp_file(filename: str, message:str):
    with open(filename, "w") as f:
        f.write(message)

if __name__ == "__main__":
    print(parse_clingo_output("test(1). \nOPTIMUM FOUND"))
    print(parse_clingo_output("test(2). test(1). \nOPTIMUM FOUND"))
    
