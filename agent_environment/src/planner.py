# a planner system for agent

import logging
from subprocess import CompletedProcess
import sys
import re
from misc import parse_clingo_output, reset_file, run_clingo, run_clingo_raw, write_to_temp_file 
from env_misc import encode_setup_data 
import unittest

class Planner:
    # initialize the planner with domain
    def __init__(self, config):
        self.id = config['id']
        #
        self.domain = config['domain']
        self.global_domain = config['global_domain']
        self.global_config = config['global_config']
        self.state_calculator = config['state_calculator']
        # 
        self.initial_state = config['initial_state']
        #
        self.planner = config['planner']
        self.plan_checking = config['plan_checking']
        # 
        self.contracts = config['contracts']
        self.clause_concern_map = config['clause_concern_map']
        self.contract_cps = config['contract_cps']
        self.cps = config['cps']
        #
        self.display_script = config['display']
        #
        # temp fiels
        self.theplan =  f"{self.id}_plan_temp.lp"
        self.observations =  f"{self.id}_obs_temp.lp"
        self.temp_file = f"{self.id}_temp.lp" 

        # initialize temp file
        reset_file(self.theplan)
        reset_file(self.observations)
        reset_file(self.temp_file)

        # initial state
        # set the initial state
        files = [self.initial_state, self.domain]
        (run_success, output) = run_clingo(files)
        if run_success:
            self.save_observations("".join(output))
        else:
            logging.error(f"failed to get the initial state - {output}")
            raise RuntimeError("failed to get initial state")
            
    # check if the observation matches with the plan
    # precondition: the plan is stored in self.theplan 
    def observation_matches_plan(self, observation: str) -> bool:
        logging.info("Check if the observation matches the plan")
        # write the observation to a temporary file
        with open(self.temp_file, "w") as f:
            f.write(observation)

        # check the observations with the expected state. 
        files = [self.plan_checking, self.temp_file, self.theplan]
        (run_success, output) = run_clingo(files)
        if run_success: 
            return True
        return False 

    def plan(self, start_time=0)-> bool:
        return self.plan_with_observation(self.get_state(), start_time=start_time)

    # plan based on the observation
    def plan_with_observation(self, observation: str, start_time=0) -> bool:
        # write observations to a temporary file
        write_to_temp_file(self.temp_file, observation)

        # the Clingo code to parse the plan from domain form to plan form.
        with open(self.temp_file, "a") as f:
            f.write(f"current_time({start_time}).")
            f.write("occur_plan(N, V, T) :- occur(N, V, T).")
            f.write("hold_plan(N, V, T) :- hold(N, V, T).")
            f.write("#show hold_plan/3.")
            f.write("#show occur_plan/3.")
        
        # plan
        # choose the files needed for the plan
        files = [self.domain, self.global_config, self.global_domain, self.state_calculator,\
                self.temp_file, self.planner,\
                self.clause_concern_map, self.cps, self.contract_cps]  
        files.extend(self.contracts)

        # run Clingo to plan
        result: CompletedProcess[bytes] = run_clingo_raw(files, flags=["-q1,2,2", "-V0", "--warn", "no-atom-undefined", "--out-atom=%s."])
        return_code = result.returncode
        if return_code == 0:
            logging.error("unknown error")
            return False
        elif return_code != 10 and return_code != 30: 
            # https://github.com/potassco/clasp/issues/42#issuecomment-459981038
            logging.error(f"error with planning - {return_code} - {result.stderr.decode()}")
            return False

        # planning is successful, save the plan 
        answer = result.stdout.decode()
        atoms = parse_clingo_output(answer)
        with open(self.theplan, "w") as f:
            f.write("".join(atoms)) 
        
        return True

    # save an observation to the state
    def save_observations(self, observations: str):
        with open(self.observations, "w") as f:
            f.write(observations)

    # see the plan, including the actions and the expected state.
    def see_plan(self):
        # parse the plan from plan form back to domain form
        with open(self.temp_file, "w") as f:
            f.write(f"occur(A, V, T) :- occur_plan(A, V, T).")
            f.write(f"hold(A, V, T) :- hold_plan(A, V, T).")
        # choose the files 
        files = [self.temp_file, self.theplan]
        # run the parsing process
        (run_success, output) = run_clingo(files)
        if run_success: 
            return "".join(output)
        
        return None

    # get the actions at step 
    def get_actions_at_step(self, step):
        # convert the plan from plan form to domain form 
        with open(self.temp_file, "w") as f:
            f.write(f"occur(A, V, T) :- occur_plan(A, V, T), target_time(T).")
            f.write(f"target_time({step}).")
            f.write("#show occur/3.")
        
        # choose the files
        files = [self.temp_file, self.theplan]
        (run_success, output) = run_clingo(files)
        if run_success: 
            return "".join(output)
        
        logging.error(f"Failed to get the plan at step {step}")
        return None 
    
    # get the state
    def get_state(self):
        with open(self.observations, "r") as f:
            return "".join(f.readlines())
    
    # get the differences between plan and observation
    def get_diff(self):
        with open(self.temp_file, "w") as f:
            f.write("target_time(T) :- hold(A, V, T).")
            f.write("target_time(T) :- occur(A, V, T).")
            f.write("max_time(A) :- A = #max{T: target_time(T)}.")
            f.write("non_max_time(T) :- not max_time(T), target_time(T).") 
            f.write("#show not_have_fluent(A) : not hold(A, V, T), hold_plan(A, V, T), target_time(T).")
            f.write("#show not_have_action(A) : not occur(A, V, T), occur_plan(A, V, T), non_max_time(T).")

        files = [self.observations, self.theplan, self.temp_file]
        (result, output) = run_clingo(files)
        if result:
            return "".join(output)
        else:
            return None

    def display(self, observation): 
        with open(self.temp_file, "w") as f:
            f.write(observation)
            f.write("#show.")
            f.write("#show hold(F, V, T) : hold(F, V, T), display(F).")
            f.write("#show occur(F, V, T) : occur(F, V, T).")
        files = [self.display_script, self.temp_file]
        (result, output) = run_clingo(files)
        if result:
            return "".join(output)
        else:
            return None

    # get the next step in the plan based on this current observation
    # if the observation does not match the plan, replan
    def next_step(self, target_step, observation:str):
        # compare the observation with the plan
        if self.observation_matches_plan(observation):
            logging.info(f"observation matches plan, get the action for {target_step}")
            return self.get_actions_at_step(target_step)
        
        logging.info("replanning...")
        # else replan if different
        self.save_observations(observation)
        self.plan(target_step)
        logging.info("replanning done")

        # check it again
        if self.observation_matches_plan(observation):
            logging.info(f"observation matches plan, get the action for {target_step}")
            return self.get_actions_at_step(target_step)
        
        # else show the differences
        return None 

