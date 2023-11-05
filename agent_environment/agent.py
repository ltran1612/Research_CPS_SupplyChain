import paho.mqtt.client as mqtt
from threading import Lock
from misc import load_config, show_config

config = load_config()
show_config(config)

publish_topic = f"env/{config['id']}" 
subscribe_topic = f"for/{config['id']}" 
received_publish_topic = f"recv/{config['id']}" 
next_subscribe_topic = f"next/{config['id']}" 

action = ""
startLock = Lock()
start = True

print(f"Publish to {publish_topic}")
print(f"Subscribe to {subscribe_topic}")

# The callback for when the client receives a CONNACK response from the server.
def on_connect(client: mqtt.Client, userdata, flags, rc):
    global start
    print("Connected with result code "+str(rc))
    startLock.acquire()
    if start:
        client.publish(received_publish_topic, "", qos=2, retain=False)
        print("told server that I'm online")
        start = False
    startLock.release()

    # Subscribing in on_connect() means that if we lose the connection and
    # reconnect then subscriptions will be renewed.
    client.subscribe(subscribe_topic)
    client.subscribe(next_subscribe_topic)

# The callback for when a PUBLISH message is received from the server.
def on_message(client: mqtt.Client, userdata, msg):
    global action
    topic: str = msg.topic
    message: str = msg.payload
    if topic == subscribe_topic:
        # received the information for this state
        print(topic, message)
        # do some reasoning
        action = input()
        # received the state information
        client.publish(received_publish_topic, "")
    elif topic == next_subscribe_topic:
        # send the action
        client.publish(publish_topic, action)
        # wait again till we can do it

client = mqtt.Client()
client.on_connect = on_connect
client.on_message = on_message

client.connect(config['brokerAddress'], 1883, 60)

# Blocking call that processes network traffic, dispatches callbacks and
# handles reconnecting.
# Other loop*() functions are available that give a threaded interface and a
# manual interface.
client.loop_forever()