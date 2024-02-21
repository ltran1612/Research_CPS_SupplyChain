# a planner system for agent

import logging
from subprocess import CompletedProcess
import sys
import re
from misc import parse_clingo_output, run_clingo, run_clingo_raw, write_to_temp_file 
from env_misc import encode_setup_data 

class Planner:
    # initialize the planner with domain
    def __init__(self, config):
        self.domain = config['domain']
        self.initial_state = config['initial_state']
        self.planner = config['planner']
        self.clause_concern_map = config['clause_concern_map']
        self.contracts = config['contracts']
        self.global_domain = config['global_domain']
        self.contract_cps = config['contract_cps']
        self.cps = config['cps']
        self.id = config['id']
        self.plan_checking = config['plan_checking']

        # temp fiels
        self.theplan =  f"{self.id}_plan_temp.lp"
        self.observations =  f"{self.id}_obs_temp.lp"
        self.temp_file = f"{self.id}_temp.lp" 

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

    def plan(self)-> bool:
        return self.plan_with_observation(self.get_state())

    # plan based on the observation
    def plan_with_observation(self, observation: str) -> bool:
        # write observations to a temporary file
        write_to_temp_file(self.temp_file, observation)

        # the Clingo code to parse the plan from domain form to plan form.
        with open(self.temp_file, "a") as f:
            f.write("occur_plan(A, T) :- occur(A, T).")
            f.write("hold_plan(A, T) :- hold(A, T).")
            f.write("#show hold_plan/2.")
            f.write("#show occur_plan/2.")
        
        # plan
        # choose the files needed for the plan
        files = [self.domain, self.temp_file, self.planner, self.clause_concern_map,\
                 self.global_domain, self.cps, self.contract_cps]  
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

    # see the plan 
    def see_plan(self):
        # parse the plan from plan form back to domain form
        with open(self.temp_file, "w") as f:
            f.write(f"occur(A, T) :- occur_plan(A, T).")
            f.write("#show occur/2.")
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
            f.write(f"occur(A, T) :- occur_plan(A, T), target_time(T).")
            f.write(f"target_time({step}).")
            f.write("#show occur/2.")
        
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
        self.plan()
        logging.info("replanning done")
        # recursively run next_step again after replanning
        return self.next_step(target_step, observation)

if __name__ == "__main__":
    # set the logging
    debug_handler = logging.StreamHandler(sys.stdout)
    debug_handler.setLevel(logging.DEBUG)
    #
    info_handler = logging.StreamHandler(sys.stdout)
    info_handler.setLevel(logging.INFO)
    #
    debug_handler.setFormatter(logging.Formatter('%(asctime)s - %(levelname)s - %(message)s'))
    info_handler.setFormatter(logging.Formatter('%(asctime)s - %(levelname)s - %(message)s'))
    #
    logger = logging.getLogger()
    logger.handlers = []
    logger.setLevel(logging.DEBUG)
    logger.addHandler(debug_handler)
    logger.addHandler(info_handler)

    # config file for planner
    config = {
        "id": "speedy_auto_part",
        "brokerAddress": "localhost",
        "domain": "../scenarios/oec-ver2/speedy_auto_part/domain.lp",
        "initial_state": "../scenarios/oec-ver2/speedy_auto_part/init.lp",
        "planner": "../scenarios/oec-ver2/speedy_auto_part/plan.lp",
        "clause_concern_map": "../scenarios/oec-ver2/speedy_auto_part/clause-concern-map.lp",
        "plan_checking": "../scenarios/oec-ver2/speedy_auto_part/plan_checking.lp",
        "global_domain": "../scenarios/oec-ver2/global_domain.lp",
        "contracts": [
            "../scenarios/oec-ver2/contracts/carprod_autopart_contract.lp",
            "../scenarios/oec-ver2/contracts/autopart_supplier_contract.lp"

        ],
        "contract_cps": "../scenarios/oec-ver2/cps/contract-cps.lp",
        "cps": "../scenarios/oec-ver2/cps/cps.lp",
        "interest": [] 
    } # end config
    plan = Planner(config)
    plan.plan()
    print("initial plan", plan.see_plan())

    state = plan.get_state()
    state += "occur(produce(vehicle_parts, 9001), 0)."
    plan.next_step(1, state)
    print("new plan", plan.see_plan())

    # check the encoder and decoder
    config = encode_setup_data(config) 
    # print(config)
    # print(decode_setup_data(config))
