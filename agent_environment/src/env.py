# The environment process representing the state of the supply chain in the simulation
# Its goal is to:
# 1) Receive actions from the agents. 
# 2) Calculate the state changes. 
# 3) Return the information to the agent about the action. 

# libraries 
from threading import Lock
import json
import logging, sys
import paho.mqtt.client as mqtt
# custom libraries
from config import load_config, show_config, TOPICS
from env_misc import Received, StateMangerGlobal 

# load and display the config
config = load_config(sys.argv)
show_config(config)
# extract the required information from the config file
agents = config['agents']
global_domain_filepath = config["global_domain"]
global_config = config["global_config"]
state_calculator = config["state_calculator"]
cps_reasoner = config["cps-reasoner"]
ontologies = config["ontologies"]

# initialized the received queue  
received = Received(agents) 
# step or time stamp of the simulation
step = -1

# the state engine simulation
state = StateMangerGlobal(agents, global_domain_filepath, global_config, state_calculator, cps_reasoner, ontologies) 

# The callback for when the client receives a CONNACK response from the server.
def on_connect(client: mqtt.Client, userdata, flags, rc):
    logging.debug("Connected with result code "+str(rc))
    # Subscribing in on_connect() means that if we lose the connection and
    # reconnect then subscriptions will be renewed.
    client.subscribe(f"{TOPICS['FOR_ENV']}/+")

# The callback for when a PUBLISH message is received from the server.
def on_message(client: mqtt.Client, userdata, msg):
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

    # check if this is the message containing the action information meant for the env from the agent. 
    # there could be other topics
    if topic == f"{TOPICS['FOR_ENV']}/{agent}":
        logging.info(f"received from {agent} for time {step}")
        # if the state simulation engine is not set up yet
        # the message sent by the agent is the setup message
        # containing the initial state and the domain of the agent
        if not state.is_setup():
            state.setup(agent, message)
        else: # this is the message containing the action
            state.receive_message(agent, message)
        # record that we received from the agent
        received.receive(agent)
        # start the simulation
        simulate()

# setup the MQTT client
client = mqtt.Client()
client.on_connect = on_connect
client.on_message = on_message

# function to simulate
simLock= Lock()
def simulate(): 
    global step

    # if we haven't received from all agents 
    # return to wait for more 
    if not received.received_all():
        return

    # if the sim lock is already acquired
    # it means that
    # 1) we have received from all agents
    # 2) there is already a process running the simulation
    # so we can just exit
    if not simLock.acquire(blocking=False):
        return

    # increase the step
    step += 1 
    logging.info(f"starting the next step {step}")
    # if we passed the last step as described in the simulation
    # exit the simulation 
    if step > state.get_last_step():
        sys.exit(0)
    logging.info(f"started the next step {step}")

    # calcualte the global next state
    state.calculate_state(step)

    # display the clauses and concerns satisfied 
    logging.info(f"clauses and concerns satisfaction are:\n{state.display_sat_concerns(step)}")

    # then, for each agent, pick out the requested information to send to them. 
    for agent in agents:
        # get only the relevant portion of information that relates to the agent
        message = {"time": step, "state": state.get_state(agent, step)}
        # send it
        client.publish(f"{TOPICS['FOR_AGENT']}/{agent}", json.dumps(message), qos=2, retain=False)
        logging.info(f"sent state information to {agent} for time {step}")

    logging.info(f"sent state information to {agent} for time {step}")
    # reset received array to get ready for the next round
    received.reset()
    simLock.release()


# set the logging
log_handler = logging.StreamHandler(sys.stdout)
log_handler.setLevel(logging.INFO)
log_handler.setFormatter(logging.Formatter('%(asctime)s - %(levelname)s - %(message)s'))
logging.getLogger().setLevel(logging.INFO)
logging.getLogger().addHandler(log_handler)

# run the thread
client.connect(config['brokerAddress'], 1883, 0)

# Blocking call that processes network traffic, dispatches callbacks and
# handles reconnecting.
# Other loop*() functions are available that give a threaded interface and a
# manual interface.
client.loop_forever()
