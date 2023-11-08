format_atoms = -V0 --out-atom=%s. 
get_lines = | head -n1 | tr ' ' '\n'
into_lines = ${format_atoms} ${get_lines} 

cps_contract = cps/cps.lp cps/contract-cps.lp clauses.lp 
builder = builder/domain.lp  builder/test_init.lp 
lumber = lumber/domain.lp lumber/test_init.lp 
run_clingo = clingo global_domain.lp
surpress = --warn no-atom-undefined


all:
	echo " all target"
lumber_co: 
	${run_clingo} ${lumber} $(into_lines)
builder_co: 
	${run_clingo} ${builder} $(into_lines)
cps_builder:
	${run_clingo} ${builder} builder/clause-concern-map.lp ${cps_contract} $(into_lines) 

plan_cps_builder:
	${run_clingo} 1 ${builder} builder/clause-concern-map.lp builder/plan.lp ${cps_contract} ${surpress} $(format_atoms)  

plan_cps_lumber:
	${run_clingo} -q1 ${lumber} lumber/clause-concern-map.lp lumber/plan.lp ${cps_contract} ${surpress} $(format_atoms) 

env_builder_lumber: 
	${run_clingo} env/builder_lumber_env.lp env/tests/builder.lp ${into_lines}

env_lumber_builder: 
	${run_clingo} env/lumber_builder_env.lp env/tests/lumber.lp ${into_lines}

cps:
	clingo cps/cps.lp cps/test.lp 