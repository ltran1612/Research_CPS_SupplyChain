# a planner object
import logging
from subprocess import CompletedProcess
import sys
from src.misc import parse_output, run_clingo

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
        self.theplan = "" 

    # TODO:  
    def observation_matches_plan(self, observation):
        pass

    def plan(self, observation):
        # write observations to a temporary file
        temp_file = f"{self.id}_temp.lp" 
        with open(temp_file, "w") as f:
            f.write(observation)
        
        # get the plan
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
        answer = "\n".join(answer)
        self.theplan = answer

    def next_step(self, target_step, observation=""):
        # compare the observation with the plan
        if self.observation_matches_plan(observation):
            # TODO: 
            # return the action at the target step
            return ""

        # else replan if different
        self.plan(observation)
        # then, return the target step
        # TODO:

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
        "cps": "../scenarios/builder_lumber/cps/cps.lp"
    }

    plan = Planner(config)

    # see the plan