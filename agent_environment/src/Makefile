SCENARIO_FOLDER = ../config/oec-ver2
all: 

env: 
	python3 env.py ${SCENARIO_FOLDER}/env_config.json

agent: 
	python3 agent.py ${SCENARIO_FOLDER}/${ID}_config.json

test:
	python3 -m unittest tests/test_planner.py

clean:
	sh clean.sh

