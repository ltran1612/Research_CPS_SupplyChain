import logging, sys
import paho.mqtt.client as mqtt

# custom libraries
from config import load_config, show_config 
from threading import Thread 
from time import sleep
from env_misc import Received, StateMangerIndividual

# load and display the config
config = load_config(sys.argv)
show_config(config)

# parse the config
actions_success_rules = config['actions_success_rules']
# get the parsers
global_state_rules = config['global_state_rules']
# get the list of agents
agents = config['agents']
# get the file path to the global domain 
global_domain_filepath = config["global_domain"]

# initialized the received queue  
received = Received(agents) 
# step
step = -1

# set up
state = StateMangerIndividual(agents, global_domain_filepath, actions_success_rules, global_state_rules) 

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
            return
        state.receive_message(agent, message)
    elif topic == f"recv/{agent}":
        logging.info(f"{agent} received")
        received.receive(agent)

client = mqtt.Client()
client.on_connect = on_connect
client.on_message = on_message

# custom environment function

# custom loop function that will loop forever
def custom_loop(): 
    while True:
        global step

        # all users have received the information we sent
        # sent them the message to do the next step
        if received.received_all() or (state.is_setup() and step == -1): 
            # environment control the signal for the next step
            # increase the step
            step += 1 
            logging.info(f"starting the next step {step}")
            if step == 71:
                sys.exit(0)
            logging.info(f"started the next step {step}")
            # send a message to each agent so they will send the action for previous step
            for agent in agents:
                client.publish(f"next/{agent}", str(step), qos=2, retain=False)

            # reset received array
            received.reset()

        # we received fully everything
        # compile information
        # send the information to each agent
        if state.received_all():
            # calcualte the global next state
            state.calculate_state(step)

            # then, for each agent, pick out the important information. 
            for agent in agents:
                # take the message from the agent that concerns this agent.
                client.publish(f"for/{agent}", state.get_state(agent), qos=2)
                logging.info(f"sent state information to {agent} for time {step}")

        # sleep for 1 second
        sleep(1)

# set the logging
log_handler = logging.StreamHandler(sys.stdout)
log_handler.setLevel(logging.INFO)
log_handler.setFormatter(logging.Formatter('%(asctime)s - %(levelname)s - %(message)s'))
logging.getLogger().setLevel(logging.INFO)
logging.getLogger().addHandler(log_handler)

# run the thread
my_thread = Thread(target=custom_loop, args=())
my_thread.start()
client.connect(config['brokerAddress'], 1883, 60)

# Blocking call that processes network traffic, dispatches callbacks and
# handles reconnecting.
# Other loop*() functions are available that give a threaded interface and a
# manual interface.
client.loop_forever()