# UI shower
# listen to and display:
# 1) Action at each time step. (DONE)
# 3) The state of each agent. (DONE)
# 4) The plan for each agent.  (DONE)
# 5) The concerns of supply chain and their satisfaction (DONE)

# libraries 
import json
from threading import Lock, Thread
import logging, sys
import paho.mqtt.client as mqtt
from config import TOPICS
from ui.datamodels.agent import AgentDataModel
from ui.datamodels.agents import AgentListModel
from ui.datamodels.cons import ConcernModel
from ui.showui import start_ui 
# custom libraries


# load and display the config
broker_addr = sys.argv[1]
# time
time = -1
# agents
agents = AgentListModel()
# concerns
concerns = ConcernModel()

# The callback for when the client receives a CONNACK response from the server.
def on_connect(client: mqtt.Client, userdata, flags, rc):
    logging.debug("Connected with result code "+str(rc))
    # Subscribing in on_connect() means that if we lose the connection and
    # reconnect then subscriptions will be renewed.
    client.subscribe(f"{TOPICS['FOR_ENV']}/+")
    client.subscribe(f"{TOPICS['FOR_AGENT']}/+")
    client.subscribe(f"{TOPICS['CONCERNS_REQUIREMENTS']}")
    client.subscribe(f"{TOPICS['PLAN']}/+")

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
        pass
    
    if topic.startswith(TOPICS['FOR_ENV']):
        # if this is a config file from the agent, ignore
        if len(message) > 0 and message[0] != "{":
            print(f"-> Action of Agent {agent}: {message}")
            magent: AgentDataModel = agents[agent]
            magent.load_action(message)
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

    if topic == TOPICS['CONCERNS_REQUIREMENTS']:
        data = json.loads(message)
        t = data["time"]
        # update the time
        if time != t:
            time = t
            print(f"\nTime {time}:")
        
        # print the concerns
        sat_concerns = data["sat"]
        concerns.load_from_string(sat_concerns)
        print(concerns)

    if topic.startswith(TOPICS["PLAN"]):
        data = json.loads(message)
        t = data["time"]

        plan = data["plan"]
        if agent not in agents:
            agents[agent] = AgentDataModel("", agent)
        magent: AgentDataModel = agents[agent]
        magent.load_plan(plan)


# setup the MQTT client
client = mqtt.Client()
client.on_connect = on_connect
client.on_message = on_message

# set the logging
log_handler = logging.StreamHandler(sys.stdout)
log_handler.setLevel(logging.INFO)
log_handler.setFormatter(logging.Formatter('%(asctime)s - %(levelname)s - %(message)s'))
logging.getLogger().setLevel(logging.ERROR)
logging.getLogger().addHandler(log_handler)

client.connect(broker_addr, 1883, 0)
client.loop_start()

start_ui(agents, concerns)
client.loop_stop()