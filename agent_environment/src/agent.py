import paho.mqtt.client as mqtt
from threading import Lock
from subprocess import CompletedProcess
from misc import load_config, show_config, run_clingo, parse_output
import logging, sys

# a planner object
class Planner:
    def __init__(self, config):
        self.domain = config['domain']
        self.initial_state = config['initial_state']
        self.planner = config['planner']
        self.clause_concern_map = config['clause_concern_map']
        self.clauses = config['clauses']
        self.global_domain = config['global_domain']
        self.contract_cps = config['contract_cps']
        self.cps = config['cps']
        self.id = config['id']

    def plan(self, observation=""):
        temp_file = f"{self.id}_temp.lp" 
        with open(temp_file, "w") as f:
            f.write(observation)
        files = [self.domain, self.initial_state, self.planner, self.clause_concern_map,\
                 self.clauses, self.global_domain, self.cps, self.contract_cps,\
                 temp_file]  
        result: CompletedProcess[bytes] = run_clingo(files, flags=["1", "-V0", "--warn", "no-atom-undefined", "--out-atom=%s."])
        return_code = result.returncode
        if return_code == 0:
            logging.info("unknown error")
            exit(1)
        elif return_code != 10 and return_code != 30: 
            logging.error(f"{return_code} - {result.stderr.decode()}")
            exit(1)
        
        answer = result.stdout.decode()
        answer = parse_output(answer)
        return "\n".join(answer)

# load config and display it
config = load_config()
show_config(config)
planner: Planner = Planner(config)

# agent topics
publish_topic = f"env/{config['id']}" 
subscribe_topic = f"for/{config['id']}" 
received_publish_topic = f"recv/{config['id']}" 
next_subscribe_topic = f"next/{config['id']}" 

# store the action for the step
action = ""

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
        client.publish(received_publish_topic, "", qos=2, retain=False)
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

    # get the topic and messages
    topic: str = msg.topic
    message: str = msg.payload.decode("ascii")

    # if the topic matches our needed topic 
    if topic == subscribe_topic:
        # received the information for this state
        logging.info(f"{topic} - {message}")
        # do some reasoning
        action = planner.plan(message)
        logging.debug(f"the planned action is {action}")
        # received the state information
        client.publish(received_publish_topic, "")
        logging.debug("notified the env that the agent received the environment information")
    elif topic == next_subscribe_topic:
        # send the action then wait again till we can do it
        client.publish(publish_topic, action)
        step = int(message)-1
        if step == -1:
            logging.info(f"the env realized this agent existence")
        else:
            logging.info(f"sent the action done at step {step} to the env")

# set the logging
log_handler = logging.StreamHandler(sys.stdout)
log_handler.setLevel(logging.DEBUG)
log_handler.setFormatter(logging.Formatter('%(asctime)s - %(levelname)s - %(message)s'))
logger = logging.getLogger()
logger.handlers = []
logger.setLevel(logging.DEBUG)
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