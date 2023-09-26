import paho.mqtt.client as mqtt
from misc import load_config, show_config

config = load_config()
show_config(config)

pairs = config['pairs']
agents = list(pairs.keys())

# The callback for when the client receives a CONNACK response from the server.
def on_connect(client: mqtt.Client, userdata, flags, rc):
    print("Connected with result code "+str(rc))
    # Subscribing in on_connect() means that if we lose the connection and
    # reconnect then subscriptions will be renewed.
    client.subscribe('env/+')

# The callback for when a PUBLISH message is received from the server.
def on_message(client: mqtt.Client, userdata, msg):
    print(msg.topic+" "+str(msg.payload))
    topic: str = msg.topic
    for agent in agents:
        if topic == f"env/{agent}":
            for dest in pairs[agent]:
                print(f"publish to {dest}")
                client.publish(f"for/{dest}", msg.payload, qos=2, retain=False)

client = mqtt.Client()
client.on_connect = on_connect
client.on_message = on_message

client.connect(config['brokerAddress'], 1883, 60)

# Blocking call that processes network traffic, dispatches callbacks and
# handles reconnecting.
# Other loop*() functions are available that give a threaded interface and a
# manual interface.
client.loop_forever()