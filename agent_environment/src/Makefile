SCENARIO_FOLDER = ../config/oec-ver3
all: 

env: 
	python3 env.py ${SCENARIO_FOLDER}/env_config.json
env_test: 
	python3 env.py ${SCENARIO_FOLDER}/env_test_config.json

agent: 
	python3 agent.py ${SCENARIO_FOLDER}/${ID}_config.json
car_producer:
	python3 agent.py ${SCENARIO_FOLDER}/x_config.json
speedy:
	python3 agent.py ${SCENARIO_FOLDER}/a_config.json
supplier_of_speedy:
	python3 agent.py ${SCENARIO_FOLDER}/as_config.json
precision_engine:
	python3 agent.py ${SCENARIO_FOLDER}/p_config.json
metal:
	python3 agent.py ${SCENARIO_FOLDER}/m_config.json
supplier_of_metal:
	python3 agent.py ${SCENARIO_FOLDER}/ms_config.json
sonic: 
	python3 agent.py ${SCENARIO_FOLDER}/e_config.json
supplier_of_sonic: 
	python3 agent.py ${SCENARIO_FOLDER}/es_config.json

test:
	python3 -m unittest tests/test_planner.py

clean:
	sh clean.sh

