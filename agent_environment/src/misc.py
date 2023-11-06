import sys, subprocess
import json


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



def run_clingo(files: list):
    command = ["clingo"]
    command.extend(files)
    command.extend(["-V0", "--out-atom=%s."]) 
    result= subprocess.run(command, capture_output=True)
    return result
    
