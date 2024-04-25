from threading import Lock
import json
import logging, sys
import paho.mqtt.client as mqtt

# custom libraries
from config import load_config, show_config 
from env_misc import Received, StateMangerGlobal 

# load and display the config
config = load_config(sys.argv)
show_config(config)
#
agents = config['agents']
global_domain_filepath = config["global_domain"]
global_config = config["global_config"]
state_calculator = config["state_calculator"]
cps_reasoner = config["cps-reasoner"]
ontologies = config["ontologies"]
#

# initialized the received queue  
received = Received(agents) 
# step
step = -1

# set up
state = StateMangerGlobal(agents, global_domain_filepath, global_config, state_calculator, cps_reasoner, ontologies) 

# The callback for when the client receives a CONNACK response from the server.
def on_connect(client: mqtt.Client, userdata, flags, rc):
    logging.debug("Connected with result code "+str(rc))
    # Subscribing in on_connect() means that if we lose the connection and
    # reconnect then subscriptions will be renewed.
    client.subscribe('env/+')
    client.subscribe('recv/+')

# The callback for when a PUBLISH message is received from the server.
def on_message(client: mqtt.Client, userdata, msg):
    topic: str = msg.topic
    message: str = str(msg.payload.decode("ascii"))
    agent = ""

    # 
    try:
        agent = topic[topic.rindex("/")+1:]
    except ValueError as e:
        logging.error(e)

    if topic == f"env/{agent}":
        logging.info(f"received from {agent} for time {step}")
        if not state.is_setup():
            state.setup(agent, message)
        else:
            state.receive_message(agent, message)
        received.receive(agent)
        simulate()

client = mqtt.Client()
client.on_connect = on_connect
client.on_message = on_message

# custom loop function that will loop forever
simLock= Lock()
def simulate(): 
    global step

    if not received.received_all():
        return

    if not simLock.acquire(blocking=False):
        return

    # all users have received the information we sent
    # sent them the message to do the next step
    # increase the step
    step += 1 
    logging.info(f"starting the next step {step}")
    if step > state.get_last_step():
        sys.exit(0)
    logging.info(f"started the next step {step}")

    # calcualte the global next state
    state.calculate_state(step)

    # display state
    logging.info(f"clauses and concerns satisfaction are:\n{state.display_sat_concerns()}")

    # then, for each agent, pick out the important information. 
    for agent in agents:
        # take the message from the agent that concerns this agent.
        message = {"time": step, "state": state.get_state(agent, step)}
        client.publish(f"for/{agent}", json.dumps(message), qos=2, retain=False)
        logging.info(f"sent state information to {agent} for time {step}")

    logging.info(f"sent state information to {agent} for time {step}")
    # reset received array
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