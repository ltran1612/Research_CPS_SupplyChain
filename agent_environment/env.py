import paho.mqtt.client as mqtt
from misc import load_config, show_config
from threading import Lock, Thread 
from time import sleep

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
    message: str = str(msg.payload)

    print(topic, message)
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
        messageLock.acquire()
        if len(messages.keys()) == len(agents):
            # we received fully everything
            # compile information
            # send the information to each agent
            for agent in agents:
                final_message = []
                for target in pairs[agent]:
                    final_message.append(messages[target])
                final_message = "".join(final_message)
                print("send state information")
                client.publish(f"for/{agent}", final_message, qos=2)
        messageLock.release()

        receivedLock.acquire()
        if len(received) == len(agents):
            # all users have received the information we sent
            # sent them the message to do the next step
            step += 1 
            print("received all, start the next step")
            for agent in agents:
                client.publish(f"next/{agent}", str(step), qos=2, retain=False)

            received = []            

        receivedLock.release()
        sleep(1)
my_thread = Thread(target=custom_loop, args=())
my_thread.start()
client.connect(config['brokerAddress'], 1883, 60)

# Blocking call that processes network traffic, dispatches callbacks and
# handles reconnecting.
# Other loop*() functions are available that give a threaded interface and a
# manual interface.
client.loop_forever()