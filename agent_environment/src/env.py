import paho.mqtt.client as mqtt
from misc import load_config, show_config, run_clingo, write_to_temp_file
from threading import Lock, Thread 
from time import sleep
import logging
import sys
from env_misc import StateManger

# load and display the config
config = load_config()
show_config(config)
# parse the config
pairs = config['pairs']
agents = list(pairs.keys())

# messages storage
messages = {}
messageLock = Lock() 

# initialized the received queue  
received = [] 
receivedLock = Lock()

# step
step = -1

# set up
states = StateManger(agents)

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

    for agent in agents:
        if topic == f"env/{agent}":
            logging.info(f"received from {agent}")
            messageLock.acquire()
            messages[agent] = message
            messageLock.release()
        elif topic == f"recv/{agent}":
            logging.info(f"{agent} received")
            receivedLock.acquire()
            received.append(agent) 
            receivedLock.release()

client = mqtt.Client()
client.on_connect = on_connect
client.on_message = on_message

# custom loop function that will loop forever
def custom_loop(): 
    while True:
        global received
        global step
        global messages

        # we received fully everything
        # compile information
        # send the information to each agent
        messageLock.acquire()
        if len(messages.keys()) == len(agents):
            for agent in agents:
                # intialize the message to contain its current messages
                final_message = [messages[agent]]

                for target in pairs[agent]:
                    # parse the data to the right one.  
                    # append the message
                    target_name = target["name"]
                    target_parser = target["parser"]
                    message = messages[target_name]

                    # parse the message 
                    # put the message to a temporary file
                    message_file = f"env_{target_name}_temp.lp" 
                    write_to_temp_file(message_file, message)

                    # run clingo with the message
                    foundAnswerSet, answerSet = run_clingo([target_parser, message_file])
                    # check for potential error, if not clean the message
                    if not foundAnswerSet:
                        logging.error("Parsing is unsatisfiable somehow")
                        exit(1)
                    else:
                        logging.debug(f"parsed these atoms array {answerSet}")
                        # add to the final message
                        final_message.extend(answerSet)
                
                # compose the final message from the messsage of all agents 
                final_message = " ".join(final_message)
                logging.debug(f"the message from the parsing is {final_message}")
                states.add_to_state(agent, final_message)
                client.publish(f"for/{agent}", states.get_state(agent), qos=2)
                logging.info(f"sent state information to {agent}")

            # reset the messages storage
            messages = {}
        messageLock.release()

        # all users have received the information we sent
        # sent them the message to do the next step
        receivedLock.acquire()
        if len(received) == len(agents):
            step += 1 
            logging.info(f"received all, start the next step {step}")
            input()
            for agent in agents:
                client.publish(f"next/{agent}", str(step), qos=2, retain=False)

            # reset received 
            received = []            
        receivedLock.release()

        # sleep for 1 second
        sleep(1)

# set the logging
log_handler = logging.StreamHandler(sys.stdout)
log_handler.setLevel(logging.DEBUG)
log_handler.setFormatter(logging.Formatter('%(asctime)s - %(levelname)s - %(message)s'))
logging.getLogger().setLevel(logging.DEBUG)
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