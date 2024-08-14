# Project About Action Theory for Supply Chain and other Misceleneous components

## Project Structure


### 1. Main Project: A Supply Chain Simulation System using Action Language Theory with CPS Framework Ontology. 

The folder of this project is "agent_environment". It includes the subdirectories:

1. src: the source folder of the base codes.  
2. scenarios: containing Clingo action theory files. 
3. config files (files ending with "..._config.json"): containing configuration files needed by each agent's and environment. 

The src folder contains the following main files: 

1. agent.py: the agent's program. 
2. env.py: the environment's program.

#### Prerequisites
Overall, we need:

1. The Mosquitto pub/sub broker.
2. ASPOntology Hybrid Reasoner CLI.
3. Python with the right packages.

##### Prerequisite 1: Mosquitto

1. Install mosquitto following the instruction at https://mosquitto.org/download/: 
    
    Mosquitto is a MQTT broker (pubish-subscriber model) used to handle communication between agent and environemnt.  


##### Prerequisite 2: ASPOntology Hybrid Reasoner CLI

A CLI to convert .owl ontology files into Clingo ASP programs and run it with other Clingo ASP programs.
This CLI was a modified version of the original program at https://github.com/thanhnh-infinity/Research_CPS.

The Ontology HybridReasoner is in the "java-cli" git branch of the project. See the README.md in the branch for more information. A jar file of the reasoner was created; its path is "agent_environment/src/cli.jar". 

Thus, we only need to make it usable.

The jar file requires 2 programs available in the $PATH to be usable:
1. clingo: Clingo. See https://potassco.org/clingo/.
2. sparql: Sparql program (can be installed by install Jena). See https://jena.apache.org/getting_started/index.html.

The jar file was tested with Clingo 5.6.2 and Jena 5.0.0-rc1. 

##### Prerequisite 3: Python with the right packages

The system was developed with Python 3.11.6. There are no clear reasons why it would not work with later versions of Python, but it has not been tested. 

For packages, we need the "paho-mqtt" package version 2.1.0. See https://pypi.org/project/paho-mqtt/. Instructions:

1. Install paho-mqtt module for agent and environment to talk to the broker:  

        pip install paho-mqtt

#### How to run 

1. Start the MQTT broker (if not running yet, the instructions will be displayed at the time of install). You can run:

    MacOS: 

        brew services start mosquitto

    or MacOs: 

        mosquitto -c /usr/local/etc/mosquitto/mosquitto.conf



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
    
#### Run OEC

For convinience with running the OEC use case, a Makefile was written. The following is the list of targets to run each agent in the scenario.

1. Run environment:

        make env

2. Run car producer:

        make ID=x agent

3. Run speedy auto part:

        make ID=a agent

4. Run supplier of speedy auto part: 

        make ID=as agent

5. Run precision engine:

        make ID=p agent

6. Run metal crafts:

        make ID=m agent

7. Run supplier of metal crafts:

       make ID=ms agent

8. Run sonic electronics:

       make ID=e agent

9. Run supplier of sonic electronics:

       make ID=es agent

### 2. SubProject: A Node.JS API backend + frontend for the hybrid ASP + Ontology Reasoner. 

It consists of the following folders:

1. client_src
2. server_src
3. src