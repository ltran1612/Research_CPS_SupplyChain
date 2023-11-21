import sys, subprocess
import json
import logging

defaultConfig = {
    "brokerAddress": "mqtt://localhost:1883",
}

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
        pairs = config["pairs"]
        print(f"This is an Environment with these pairs set up: {json.dumps(pairs)}")


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

# run clingo and return appropriate output
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

# parse the output of running clingo on subprocess to get the list of the answer set 
# precondition: we would expect that the output comes from running clingo with the flags -V0 --output-atoms=%s.
def parse_clingo_output(output: str): 
    output = output.strip()
    lines = output.split("\n")
    lines.pop(-1)

    return get_atoms(lines)

# get only the atoms out of all of the lines
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

# write to a temporary file 
def write_to_temp_file(filename: str, message:str):
    with open(filename, "w") as f:
        f.write(message)


if __name__ == "__main__":
    print(parse_clingo_output("test(1). \nOPTIMUM FOUND"))
    print(parse_clingo_output("test(2). test(1). \nOPTIMUM FOUND"))
    
