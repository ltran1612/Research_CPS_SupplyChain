import sys
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
    
    print(f"Address to connect is {address}")
    if id:
        print(f"Agent with id {id}")
    else: 
        pairs = config["pairs"]
        print(f"Environment with these pairs set up: {json.dumps(pairs)}")


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