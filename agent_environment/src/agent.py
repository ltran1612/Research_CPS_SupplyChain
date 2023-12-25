import paho.mqtt.client as mqtt
from threading import Lock
from subprocess import CompletedProcess
from misc import load_config, show_config, get_atoms, encode_setup_data
from planner import Planner 
import logging, sys

# load config and display it
config = load_config()
show_config(config)
planner: Planner = Planner(config)
planner.plan([])

# agent topics
publish_topic = f"env/{config['id']}" 
subscribe_topic = f"for/{config['id']}" 
received_publish_topic = f"recv/{config['id']}" 
next_subscribe_topic = f"next/{config['id']}" 

# store the action for the step
action = ""

# target step 
upcoming_step = 0 

# variable to identify if we're connecting for the first time or not
# with a Lock/mutex
startLock = Lock()
start = True

logging.debug(f"Publish to {publish_topic}")
logging.debug(f"Subscribe to {subscribe_topic}")

# The callback for when the client receives a CONNACK response from the server.
def on_connect(client: mqtt.Client, userdata, flags, rc):
    global start
    logging.debug("Connected with result code "+str(rc))

    # connectting for the first time, notified the environment
    startLock.acquire()
    if start:
        # send setup information 
        client.publish(publish_topic, encode_setup_data(config), qos=2, retain=False)
        logging.info("agent notified to the env of its existence")
        start = False
    startLock.release()

    # Subscribing in on_connect() means that if we lose the connection and
    # reconnect then subscriptions will be renewed.
    client.subscribe(subscribe_topic)
    client.subscribe(next_subscribe_topic)

# The callback for when a PUBLISH message is received from the server.
def on_message(client: mqtt.Client, userdata, msg):
    global action
    global upcoming_step 

    # get the topic and messages
    topic: str = msg.topic
    message: str = msg.payload.decode("ascii")
    message = message.strip()

    # if the topic matches our needed topic 
    if topic == subscribe_topic:
        # received the information for this state
        logging.debug(f"{topic} - {message}")
        logging.info(f"The state at the start of step {upcoming_step} is: {message}")
        observations = get_atoms([message])
        # do some reasoning
        actions = planner.next_step(upcoming_step, observations)
        # assemble the actions to do into a message to send
        action = " ".join(actions)
        logging.debug(f"the next action is {action}")
        logging.info(f"the action to do in {upcoming_step} is: {action}")
        # received the state information
        client.publish(received_publish_topic, "")
        logging.debug("notified the env that the agent received the environment information")
    elif topic == next_subscribe_topic:
        # send the action then wait again till we can do it
        client.publish(publish_topic, action)
        
        # get the step number
        upcoming_step = int(message)
        if upcoming_step == 0:
            logging.info(f"the env realized this agent existence")
        else:
            logging.info(f"sent the action done at step {upcoming_step-1} to the env")

# set the logging
log_handler = logging.StreamHandler(sys.stdout)
log_handler.setLevel(logging.INFO)
log_handler.setFormatter(logging.Formatter('%(asctime)s - %(levelname)s - %(message)s'))
logger = logging.getLogger()
logger.handlers = []
logger.setLevel(logging.INFO)
logger.addHandler(log_handler)

# start the agent 
client = mqtt.Client()
client.on_connect = on_connect
client.on_message = on_message

# connect to the mqtt broker 
client.connect(config['brokerAddress'], 1883, 60)

# Blocking call that processes network traffic, dispatches callbacks and
# handles reconnecting.
# Other loop*() functions are available that give a threaded interface and a
# manual interface.
client.loop_forever()