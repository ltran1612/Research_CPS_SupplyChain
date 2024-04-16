import sys, logging
import paho.mqtt.client as mqtt
from threading import Lock
import json

# custom libraries 
from misc import get_atoms 
from env_misc import encode_setup_data
from config import show_config, load_config
from planner import Planner 

# set the logging
log_handler = logging.StreamHandler(sys.stdout)
log_handler.setLevel(logging.INFO)
log_handler.setFormatter(logging.Formatter('%(asctime)s - %(levelname)s - %(message)s'))
logger = logging.getLogger()
logger.handlers = []
logger.setLevel(logging.INFO)
logger.addHandler(log_handler)

# load config and display it
config = load_config(sys.argv)
show_config(config)

# set up planner
planner: Planner = Planner(config)

# agent topics
send_topic = f"env/{config['id']}" 
receive_topic = f"for/{config['id']}" 
logging.debug(f"Published to {send_topic}")
logging.debug(f"Subscribed to {receive_topic}")

# variable to identify if we're connecting for the first time or not
# with a Lock/mutex
startLock = Lock()
started = False
# The callback for when the client receives a CONNACK response from the server.
def on_connect(client: mqtt.Client, userdata, flags, rc):
    global started
    logging.debug("Connected with result code "+str(rc))

    # connectting for the first time, notified the environment
    startLock.acquire()
    if not started:
        # send setup information 
        client.publish(send_topic, encode_setup_data(config), qos=2, retain=False)
        logging.info("agent notified to the env of its existence")
        started = True 
    startLock.release()

    # Subscribing in on_connect() means that if we lose the connection and
    # reconnect then subscriptions will be renewed.
    client.subscribe(receive_topic)

# The callback for when a PUBLISH message is received from the server.
def on_message(client: mqtt.Client, userdata, msg):
    global action

    # get the topic and messages
    topic: str = msg.topic
    message: str = msg.payload.decode("ascii")
    message = message.strip()

    # if the topic matches our needed topic 
    if topic == receive_topic:
        # received the information for this state
        logging.debug(f"{topic} - {message}")
        state_info = json.loads(message)
        state = state_info['state']
        time_step = state_info['time']
        # print(state)
        observation = planner.display(state)
        sats = planner.display_sat_concerns()
        logging.info(f"The state at the start of step {time_step} is: {observation}")
        logging.info(f"The concern satisfaction of step {time_step} is:\n{sats}")

        # do some reasoning
        actions = planner.next_step(time_step, state)

        # get the action 
        if actions is None:
            logging.info("replan failed, cannot do anything")
            action = ""
            sys.exit(1)
        else:
            action = actions
        # 
        logging.debug(f"the next action is {action} for the end of time step {time_step}")
        # send the action then wait again till we can do it
        client.publish(send_topic, action)
        # send the action
        logging.info(f"sent the action {action} to the environment for the end of time step {time_step}")
        
#
logging.info("initial planning...")
planner.plan()
logging.info("planning done.")
sats = planner.display_sat_concerns()
logging.info(f"At the start the satisfaction of concerns are:\n{sats}")

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
