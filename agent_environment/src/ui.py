# UI shower
# listen to and display:
# 1) Action at each time step. (TODO)
# 2) The state of the environment. (TODO)
# 3) The state of each agent. (WAIT)
# 4) The plan for each agent.  (WAIT)

# libraries 
import json
from threading import Lock
import logging, sys
import paho.mqtt.client as mqtt
from config import TOPICS
from ui.datamodels.agent import AgentDataModel 
# custom libraries

# load and display the config
broker_addr = sys.argv[1]
# time
time = -1
# agents
agents:dict[str, AgentDataModel] = {}

# The callback for when the client receives a CONNACK response from the server.
def on_connect(client: mqtt.Client, userdata, flags, rc):
    logging.debug("Connected with result code "+str(rc))
    # Subscribing in on_connect() means that if we lose the connection and
    # reconnect then subscriptions will be renewed.
    client.subscribe(f"{TOPICS['FOR_ENV']}/+")
    client.subscribe(f"{TOPICS['FOR_AGENT']}/+")

# The callback for when a PUBLISH message is received from the server.
def on_message(client: mqtt.Client, userdata, msg):
    global time
    # extract the topic name
    topic: str = msg.topic
    # extract the message
    message: str = str(msg.payload.decode("ascii"))

    # get the agent from the topic name 
    agent = ""
    try:
        agent = topic[topic.rindex("/")+1:]
    except ValueError as e:
        logging.error(e)
    
    if topic.startswith(TOPICS['FOR_ENV']):
        # if this is a config file from the agent, ignore
        if message[0] != "{":
            print(f"-> Action of Agent {agent}: {message}")
    if topic.startswith(TOPICS['FOR_AGENT']):
        data = json.loads(message)
        if "time" in data: 
            t = data["time"]

            # update the time
            if time != t:
                time = t
                print(f"\nTime {time}:")
            
            # get the state
            state = data["state"]
            if agent in agents:
                agents[agent].load_from_string(state)
            else:
                agents[agent] = AgentDataModel(state, agent)
            print(agents[agent])


# setup the MQTT client
client = mqtt.Client()
client.on_connect = on_connect
client.on_message = on_message

# set the logging
log_handler = logging.StreamHandler(sys.stdout)
log_handler.setLevel(logging.ERROR)
log_handler.setFormatter(logging.Formatter('%(asctime)s - %(levelname)s - %(message)s'))
logging.getLogger().setLevel(logging.INFO)
logging.getLogger().addHandler(log_handler)

# run the thread
client.connect(broker_addr, 1883, 0)

# Blocking call that processes network traffic, dispatches callbacks and
# handles reconnecting.
# Other loop*() functions are available that give a threaded interface and a
# manual interface.
client.loop_forever()
