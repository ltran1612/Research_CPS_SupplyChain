import logging, sys
import json 

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
        agents = config["agents"]
        print(f"This is an environment with these agents: {json.dumps(agents)}")

# a function to load the config from the command line arguments
def load_config(args: list[str]):
    if len(args) > 1:
        config_path = args[1]
        text = ""
        with open(config_path, "r") as file:
            text = file.readlines()
            text = "".join(text)
        config = json.loads(text)
        return config

    return defaultConfig