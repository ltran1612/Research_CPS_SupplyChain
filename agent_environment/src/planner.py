# a planner object
import logging
from subprocess import CompletedProcess
import sys
import re
from misc import parse_clingo_output, run_clingo_raw, write_to_temp_file, encode_setup_data, decode_setup_data

class Planner:
    theplan: list

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
        self.plan_checking = config['plan_checking']
        self.theplan = [] 

    # TODO:  
    def observation_matches_plan(self, observation: list):
        checking_file = self.plan_checking
        temp_file = f"{self.id}_temp.lp" 
        write_to_temp_file(temp_file, " ".join(self.theplan) +\
                           " ".join(observation))

        files = [temp_file, checking_file, self.global_domain]

        result: CompletedProcess[bytes] = run_clingo_raw(files, flags=["-q1,2,2", "-V0", "--warn", "no-atom-undefined", "--out-atom=%s."])
        return_code = result.returncode

        if return_code == 0:
            logging.info("unknown error")
            exit(1)
        elif return_code != 10 and return_code != 30: 
            answer = result.stdout.decode()
            if "UNSATISFIABLE" in answer:
                return False
            logging.error(f"{return_code} - {result.stderr.decode()}")
            exit(1)

        return True        


    def plan(self, observation: list):
        # write observations to a temporary file
        temp_file = f"{self.id}_temp.lp" 
        write_to_temp_file(temp_file, " ".join(observation))
        
        # get the plan
        files = [self.domain, self.initial_state, self.planner, self.clause_concern_map,\
                 self.clauses, self.global_domain, self.cps, self.contract_cps,\
                 temp_file]  
        result: CompletedProcess[bytes] = run_clingo_raw(files, flags=["-q1,2,2", "-V0", "--warn", "no-atom-undefined", "--out-atom=%s."])

        return_code = result.returncode
        if return_code == 0:
            logging.info("unknown error")
            exit(1)
        elif return_code != 10 and return_code != 30: 
            # https://github.com/potassco/clasp/issues/42#issuecomment-459981038
            logging.error(f"error with planning - {return_code} - {result.stderr.decode()}")
            exit(1)
        
        answer = result.stdout.decode()
        answer = parse_clingo_output(answer)
        # answer = "\n".join(answer)
        self.theplan = answer
    
    def see_plan(self):
        return self.theplan
    
    def get_actions_at_step(self, step):
        reg = re.compile(f"occur\(.*,{step}\)\.")
        actions = list(filter(reg.match, self.theplan))
        return actions

    def next_step(self, target_step, observation=[]):
        # compare the observation with the plan
        if self.observation_matches_plan(observation):
            return self.get_actions_at_step(target_step)
        
        # else replan if different
        self.plan(observation)
        # return the next step
        return self.next_step(target_step, observation)

if __name__ == "__main__":
    # set the logging
    log_handler = logging.StreamHandler(sys.stdout)
    log_handler.setLevel(logging.DEBUG)
    log_handler.setFormatter(logging.Formatter('%(asctime)s - %(levelname)s - %(message)s'))
    logger = logging.getLogger()
    logger.handlers = []
    logger.setLevel(logging.DEBUG)
    logger.addHandler(log_handler)

    # config file for planner
    config = {
        "id": "builder",
        "brokerAddress": "localhost",
        "domain": "../scenarios/builder_lumber/builder/domain.lp",
        "initial_state": "../scenarios/builder_lumber/builder/test_init.lp",
        "planner": "../scenarios/builder_lumber/builder/plan.lp",
        "clause_concern_map": "../scenarios/builder_lumber/builder/clause-concern-map.lp",
        "global_domain": "../scenarios/builder_lumber/global_domain.lp",
        "clauses": "../scenarios/builder_lumber/clauses.lp",
        "contract_cps": "../scenarios/builder_lumber/cps/contract-cps.lp",
        "cps": "../scenarios/builder_lumber/cps/cps.lp",
        "plan_checking": "../scenarios/builder_lumber/builder/plan_checking.lp",
    }

    # plan = Planner(config)
    # plan.plan([])
    # print("initial plan", plan.see_plan())
    # input()
    # plan.next_step(1, ["occur(pay(1000, board), 0)."])
    # print("new plan", plan.see_plan())

    # check the encoder and decoder
    config = encode_setup_data(config) 
    # print(config)
    # print(decode_setup_data(config))
