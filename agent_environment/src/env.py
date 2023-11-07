import paho.mqtt.client as mqtt
from misc import load_config, show_config, run_clingo
from threading import Lock, Thread 
from time import sleep
import logging
import sys

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
                    message_file = f"{target_name}_temp.lp" 
                    with open(message_file, "w") as f:
                        f.write(message)
                    result = run_clingo([target_parser, message_file])
                    logging.debug(f"run clingo with {target_parser} and {message_file}")

                    # parse the message
                    parsed_message: str = result.stdout.decode("utf-8")
                    parsed_message = parsed_message.strip()
                    logging.debug(f"clingo output is {parsed_message}")
                    lines = parsed_message.split("\n")

                    # check for potential error, if not clean the message
                    if "UNSATISFIABLE" in lines:
                        logging.error("Parsing is unsatisfiable somehow")
                        exit(1)
                    else:
                        lines.pop()
                        logging.debug(f"parsed these atoms array {lines}")
                        # add to the final message
                        final_message.extend(lines)
                
                # compose the final message from the messsage of all agents 
                final_message = "\n".join(final_message)
                client.publish(f"for/{agent}", final_message, qos=2)
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
            for agent in agents:
                client.publish(f"next/{agent}", str(step), qos=2, retain=False)

            # reset received 
            received = []            
        receivedLock.release()

        # sleep for 1 second
        sleep(1)

# set the logging
log_handler = logging.StreamHandler(sys.stdout)
log_handler.setLevel(logging.INFO)
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