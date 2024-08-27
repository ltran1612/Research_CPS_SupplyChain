# The environment process representing the state of the supply chain in the simulation
# Its goal is to:
# 1) Receive actions from the agents. 
# 2) Calculate the state changes. 
# 3) Return the information to the agent about the action. 

# libraries 
from threading import Lock
import json
import logging, sys
from time import sleep
import paho.mqtt.client as mqtt
# custom libraries
from config import load_config, show_config, TOPICS
from env_misc import Received, StateMangerGlobal 

# load and display the config
config = load_config(sys.argv)
show_config(config)
# extract the required information from the config file
agents = config['agents']
global_domain_filepath = config["global_domain"]
global_config = config["global_config"]
state_calculator = config["state_calculator"]
cps_reasoner = config["cps-reasoner"]
ontologies = config["ontologies"]

# initialized the received queue  
received = Received(agents) 
# step or time stamp of the simulation
step = -1
# done with simulation
sim_done = True

# the state engine simulation
state = StateMangerGlobal(agents, global_domain_filepath, global_config, state_calculator, cps_reasoner, ontologies) 

# setup function for getting answer
def get_answer_func_from_ui(actions):
    global client

    # send this list of actions to the UI
    questions = {"type": "action_questions", "content": actions}
    client.publish(TOPICS["ENV_UI"], json.dumps(questions), qos=2, retain=False)
    logging.info("sent the questions to the UI to ask for actions approval.")
    return False
GET_ANSWER_FUNC = get_answer_func_from_ui

# The callback for when the client receives a CONNACK response from the server.
def on_connect(client: mqtt.Client, userdata, flags, rc, properties):
    logging.debug("Connected with result code "+str(rc))
    # Subscribing in on_connect() means that if we lose the connection and
    # reconnect then subscriptions will be renewed.
    client.subscribe(f"{TOPICS['FOR_ENV']}/+")
    # subscribe to the control topic
    client.subscribe(f"{TOPICS['UI_ENV']}")

# The callback for when a PUBLISH message is received from the server.
def on_message(client: mqtt.Client, userdata, msg):
    # 
    global GET_ANSWER_FUNC
    global sim_done
    # extract the topic name
    topic: str = msg.topic
    # extract the message
    message: str = str(msg.payload.decode("ascii"))

    # get the agent from the topic name 
    agent = ""
    try:
        agent = topic[topic.rindex("/")+1:]
    except ValueError as e:
        logging.error("Ignore: cannot parse the agent name from the topic because this might not be an agent's related topic")

    # check if this is the message containing the action information meant for the env from the agent. 
    # there could be other topics
    if topic == f"{TOPICS['FOR_ENV']}/{agent}":
        logging.info(f"received from {agent} for time {step}")
        # if the state simulation engine is not set up yet
        # the message sent by the agent is the setup message
        # containing the initial state and the domain of the agent
        if not state.is_setup():
            state.setup(agent, message)
        else: # this is the message containing the action
            state.receive_message(agent, message)
        # record that we received from the agent
        received.receive(agent)
        # start the simulation
        simulate(get_answer=GET_ANSWER_FUNC)
    
    # wait for ui's response
    # call simulate again with the answer
    if topic == f"{TOPICS['UI_ENV']}":
        message = json.loads(message)
        mtype = message["type"]
        content = message["content"]

        # handle the case when it's an answer to the actions
        if mtype == "actions_answers":
            logging.info("Got the answers about the actions from the UI.")
            # logging.info(content)
            answer = content 
            simulate(answer=answer, get_answer=GET_ANSWER_FUNC)
            return
        # other types handle here
        # start
        if mtype == "start":
            logging.info("request to start the simulation")
            start_sim()
            return
        # pause 
        if mtype == "pause":
            logging.info("request to pause the simulation")
            pause_sim()
            return

# setup the MQTT client
client = mqtt.Client(mqtt.CallbackAPIVersion.VERSION2)
client.on_connect = on_connect
client.on_message = on_message

# function to simulate
simLock= Lock()
controlLock = Lock()
sim_paused = False 
# hold and pause the sim lock
def start_sim():
    global simLock
    global controlLock
    global sim_paused
    global client 

    try:
        # only one thread can control at one time
        if not controlLock.acquire(blocking=False):
            return

        # release the sim lock
        # case 1: the sim is unlocked
        if not simLock.locked():
            return

        # if the sim is not paused 
        if not sim_paused:
            return

        # case 2: the sim is locked
        # release the simLock
        simLock.release()
        # unpause the sim
        sim_paused = False
        # notify the agent
        message = {"type": "started", "content": ""}
        client.publish(TOPICS["ENV_UI"], json.dumps(message), qos=2, retain=False)
        # logging
        logging.info("The simulation is started.")
        # simulate
        simulate(get_answer=GET_ANSWER_FUNC)
    except Exception as e:
        logging.error(e)
    finally:
        # release it
        controlLock.release()

def pause_sim():
    global sim_paused
    global simLock

    try:
        # only one thread can control at one time
        if not controlLock.acquire(blocking=False):
            return

        # hold the sim lock
        # case 1: the lock is not hold
        # case 2: the lock is hold, wait until done
        # what to do with multiple pauses request, in this case, just one is enough, exit
        if sim_paused:
            return

        if simLock.acquire(blocking=True):    
            sim_paused = True
            # notify the agent
            message = {"type": "paused", "content": ""}
            client.publish(TOPICS["ENV_UI"], json.dumps(message), qos=2, retain=False)
            logging.info("The simulation is paused.")
    except Exception as e:
        logging.error(e)
    finally:
        # release it    
        controlLock.release()

def simulate(answer=None, get_answer=None): 
    global step
    global sim_done
    global simLock

    # if we haven't received from all agents 
    # return to wait for more 
    if not received.received_all():
        return

    # if the sim lock is already acquired
    # it means that
    # 1) we have received from all agents
    # 2) there is already a process running the simulation
    # so we can just exit
    if not simLock.acquire(blocking=False):
        return

    if sim_done:
        # increase the step
        step += 1 
        logging.info(f"starting the next step {step}")
        # if we passed the last step as described in the simulation
        # exit the simulation 
        if step > state.get_last_step():
            sys.exit(0)
        logging.info(f"started the next step {step}")

    # calcualte the global next state
    got_error, sim_done, error = state.calculate_state(step, answer=answer, get_answer=get_answer)
    if got_error:
        # TODO: handle the error case here
        pass

    if sim_done:
        # publish the state
        env_state = state.get_env_state(step)
        message = {"time": step, "state": env_state}
        client.publish(TOPICS["ENV_STATE"], json.dumps(message), qos=2, retain=False)

        # display the clauses and concerns satisfied 
        sat_concerns = state.display_sat_concerns(step)
        logging.info(f"clauses and concerns satisfaction are:\n{sat_concerns}")
        message = {"time": step, "sat": sat_concerns}
        client.publish(TOPICS["CONCERNS_REQUIREMENTS"], json.dumps(message), qos=2, retain=False)

        # then, for each agent, pick out the requested information to send to them. 
        for agent in agents:
            # get only the relevant portion of information that relates to the agent
            message = {"time": step, "state": state.get_state(agent, step)}
            # send it
            client.publish(f"{TOPICS['FOR_AGENT']}/{agent}", json.dumps(message), qos=2, retain=False)
            logging.info(f"sent state information to {agent} for time {step}")

        logging.info(f"sent state information to {agent} for time {step}")
        # reset received array to get ready for the next round
        received.reset()
    simLock.release()


# set the logging
log_handler = logging.StreamHandler(sys.stdout)
log_handler.setLevel(logging.INFO)
log_handler.setFormatter(logging.Formatter('%(asctime)s - %(levelname)s - %(message)s'))
logging.getLogger().setLevel(logging.INFO)
logging.getLogger().addHandler(log_handler)

# run the thread
client.connect(config['brokerAddress'], 1883, 0)

# Blocking call that processes network traffic, dispatches callbacks and
# handles reconnecting.
# Other loop*() functions are available that give a threaded interface and a
# manual interface.
client.loop_forever()
