# UI shower
# listen to and display:
# 1) Action at each time step. (TODO)
# 2) The state of the environment. (TODO)
# 3) The state of each agent. (WAIT)
# 4) The plan for each agent.  (WAIT)

# libraries 
from threading import Lock
import logging, sys
import paho.mqtt.client as mqtt
from config import TOPICS 
# custom libraries

# load and display the config
broker_addr = sys.argv[1]

# The callback for when the client receives a CONNACK response from the server.
def on_connect(client: mqtt.Client, userdata, flags, rc):
    logging.debug("Connected with result code "+str(rc))
    # Subscribing in on_connect() means that if we lose the connection and
    # reconnect then subscriptions will be renewed.
    client.subscribe(f"{TOPICS['FOR_ENV']}/+")
    client.subscribe(f"{TOPICS['FOR_AGENT']}/+")

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

# setup the MQTT client
client = mqtt.Client()
client.on_connect = on_connect
client.on_message = on_message

# set the logging
log_handler = logging.StreamHandler(sys.stdout)
log_handler.setLevel(logging.INFO)
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
