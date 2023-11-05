import paho.mqtt.client as mqtt
from misc import load_config, show_config
from threading import Lock, Thread 
from time import sleep
import subprocess

config = load_config()
show_config(config)

pairs = config['pairs']
agents = list(pairs.keys())
messages = {}
messageLock = Lock() 

received = [] 
step = 0
receivedLock = Lock()


# The callback for when the client receives a CONNACK response from the server.
def on_connect(client: mqtt.Client, userdata, flags, rc):
    print("Connected with result code "+str(rc))
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
            print(f"received from {agent}")
            messageLock.acquire()
            messages[agent] = message
            messageLock.release()
        elif topic == f"recv/{agent}":
            print(f"{agent} received")
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
                final_message = []
                for target in pairs[agent]:
                    # parse the data to the right one.  
                    # append the message
                    target_name = target["name"]
                    target_parser = target["parser"]
                    message = messages[target_name]

                    # parse the message
                    name = f"{target_name}_temp.lp" 
                    with open(name, "w") as f:
                        f.write(message)
                    command = ["clingo", target_parser, name] 
                    result= subprocess.run(command, capture_output=True)
                    parsed_message = result.stdout.decode("utf-8")

                    # add to the final message
                    final_message.append(parsed_message)

                final_message = "\n".join(final_message)
                print("send state information")
                client.publish(f"for/{agent}", final_message, qos=2)
            # reset the messages storage
            messages = {}
        messageLock.release()

        # all users have received the information we sent
        # sent them the message to do the next step
        receivedLock.acquire()
        if len(received) == len(agents):
            step += 1 
            print("received all, start the next step")
            for agent in agents:
                client.publish(f"next/{agent}", str(step), qos=2, retain=False)

            # reset received 
            received = []            

        receivedLock.release()
        sleep(1)

# run the thread
my_thread = Thread(target=custom_loop, args=())
my_thread.start()
client.connect(config['brokerAddress'], 1883, 60)

# Blocking call that processes network traffic, dispatches callbacks and
# handles reconnecting.
# Other loop*() functions are available that give a threaded interface and a
# manual interface.
client.loop_forever()