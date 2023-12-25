# Project About Action Theory for Supply Chain and other Misceleneous components

## Project Structure

### A Node.JS API backend + frontend for the hybrid ASP + Ontology Reasoner. 

It consists of the following folders:

1. client_src
2. server_src
3. src

### An agent environment coordination program for testing action theory with Clingo. 

It consists of the following folders:

1. agent_environment:

    a. src: the source folder of the base codes.  
    b. scenarios: containing Clingo action theory files for experimenting. 
    c. config files (files ending with "..._config.json"): defining the files needed by each agent's and environment. 

The src folder contains the following files: 

1. agent.py: the code for running individual agent.
2. env.py: the code for running the environment. 
3. env_misc.py: some functions that env.py needs. 
4. misc.py: some codes that both the environment and agent needs. 
5. parser_factory.py: A parser factory to generate parsers to get fluent and actions' names. 
6. planner.py: A planner defining the behaviour of each individual agent. 

#### Prerequisites

1. Install mosquitto following the instruction at https://mosquitto.org/download/: 
    
    Mosquitto is a MQTT broker (pubish-subscriber model) used to handle communication between agent and environemnt.  

2. Install paho-mqtt module for agent and environment to talk to the broker:  

        pip install paho-mqtt

    Link: https://pypi.org/project/paho-mqtt/

#### How to run 

1. Start the MQTT broker (if not running yet, the instructions will be displayed at the time of install). You can run:

    a. 

    b. 

2. Start the environment:

    a. In a different terminal tab/session, go to the src folder of agent_environment. 

    b. Run:

        python3 env.py <path_to_env_config>

    For example:

        python3 env.py ../env_config.json

1. Start the agent
    
    a. In a different terminal tab/session, go to the src folder of agent_environment. 

    b. Run:

        python3 agent.py <path_to_agent_config> 
    
    For example: 

        python3 agent.py ../agent1_config.json

    and 

        python3 agent.py ../agent2_config.json