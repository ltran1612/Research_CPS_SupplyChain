DOMAIN = general/domain.lp global_domain.lp state_calculator.lp
INIT = general/init.lp
PLAN = general/plan.lp
HIDE_WARNING = -q2,2,2 --warn no-atom-undefined -V0
all: test1 test2 test3 test4 test5 test6 test16 test17 test18 test19 test20 test21 

.SILENT:
test1:
	echo $@
	head -n2 tests/test1.lp
	@-clingo ${DOMAIN} ${INIT} tests/test1.lp ${HIDE_WARNING}
	head -n2 tests/test1.1.lp
	@-clingo ${DOMAIN} ${INIT} tests/test1.1.lp  ${HIDE_WARNING}
	echo ""

.SILENT:
test2:
	echo $@
	head -n2 tests/test2.lp
	@-clingo ${DOMAIN} tests/test2.lp ${HIDE_WARNING}  
	
	echo "" 
	head -n2 tests/test2.1.lp
	@-clingo ${DOMAIN} tests/test2.1.lp ${HIDE_WARNING} 

	echo "" 
	head -n2 tests/test2.2.lp
	@-clingo ${DOMAIN} tests/test2.2.lp   ${HIDE_WARNING}

	echo "" 
	head -n2 tests/test2.3.lp
	@-clingo ${DOMAIN} tests/test2.3.lp ${HIDE_WARNING}

	echo "" 
	head -n2 tests/test2.4.lp
	@-clingo ${DOMAIN} tests/test2.4.lp ${HIDE_WARNING}

	echo "" 
	head -n2 tests/test2.5.lp
	@-clingo ${DOMAIN} tests/test2.5.lp ${HIDE_WARNING}

	echo ""

.SILENT:
test3:
	echo $@
	head -n2 tests/test3.lp
	@-clingo ${DOMAIN} ${INIT} tests/test3.lp  ${HIDE_WARNING}

	echo ""
	head -n2 tests/test3.1.lp
	@-clingo ${DOMAIN} ${INIT} tests/test3.1.lp  ${HIDE_WARNING}

	echo ""

.SILENT:
test4:
	echo $@
	head -n2 tests/test4.lp
	@-clingo ${DOMAIN} tests/test4.lp ${HIDE_WARNING} 

	echo ""
	head -n2 tests/test4.1.lp
	@-clingo ${DOMAIN} tests/test4.1.lp ${HIDE_WARNING}
	
	echo ""
	head -n2 tests/test4.2.lp
	@-clingo ${DOMAIN} tests/test4.2.lp ${HIDE_WARNING}

	echo ""

.SILENT:
test5:
	echo $@
	head -n2 tests/test5.lp
	@-clingo ${DOMAIN} tests/test5.lp ${HIDE_WARNING}

	echo ""
	head -n2 tests/test5.1.lp
	@-clingo ${DOMAIN} tests/test5.1.lp ${HIDE_WARNING}

	echo ""
	head -n2 tests/test5.2.lp
	@-clingo ${DOMAIN} tests/test5.2.lp ${HIDE_WARNING}

	echo ""
	head -n2 tests/test5.3.lp
	@-clingo ${DOMAIN} tests/test5.3.lp ${HIDE_WARNING}

	echo ""
	head -n2 tests/test5.4.lp
	@-clingo ${DOMAIN} tests/test5.4.lp ${HIDE_WARNING}

	echo ""
	head -n2 tests/test5.5.lp
	@-clingo ${DOMAIN} tests/test5.5.lp ${HIDE_WARNING}

	# echo ""
	# head -n2 tests/test5.6.lp
	# @-clingo ${DOMAIN} tests/test5.6.lp ${HIDE_WARNING}

	# echo ""
	# head -n2 tests/test5.7.lp
	# @-clingo ${DOMAIN} tests/test5.7.lp ${HIDE_WARNING}

	# echo ""
	# head -n2 tests/test5.8.lp
	# @-clingo ${DOMAIN} tests/test5.8.lp ${HIDE_WARNING}
	# echo ""
	
.SILENT:
test6:
	echo $@
	head -n2 tests/test6.lp
	@-clingo ${DOMAIN} tests/test6.lp ${HIDE_WARNING} 

	echo ""
	head -n2 tests/test6.1.lp
	@-clingo ${DOMAIN} tests/test6.1.lp ${HIDE_WARNING} 

	# echo ""
	# head -n2 tests/test6.2.lp
	# @-clingo ${DOMAIN} tests/test6.2.lp ${HIDE_WARNING}

	# echo ""
	# head -n2 tests/test6.3.lp
	# @-clingo ${DOMAIN} tests/test6.3.lp ${HIDE_WARNING}

	# echo ""
	# head -n2 tests/test6.4.lp
	# @-clingo ${DOMAIN} tests/test6.4.lp ${HIDE_WARNING}

	# echo ""
	# head -n2 tests/test6.5.lp
	# @-clingo ${DOMAIN} tests/test6.5.lp ${HIDE_WARNING}

	# echo ""
	# head -n2 tests/test6.6.lp
	# @-clingo ${DOMAIN} tests/test6.6.lp ${HIDE_WARNING}

	# echo ""
	# head -n2 tests/test6.7.lp
	# @-clingo ${DOMAIN} tests/test6.7.lp ${HIDE_WARNING}

	# echo ""
	# head -n2 tests/test6.8.lp
	# @-clingo ${DOMAIN} tests/test6.8.lp ${HIDE_WARNING}

	# echo ""
	# head -n2 tests/test6.9.lp
	# @-clingo ${DOMAIN} tests/test6.9.lp ${HIDE_WARNING}
	
	# echo ""
	# head -n2 tests/test6.10.lp
	# @-clingo ${DOMAIN} tests/test6.10.lp ${HIDE_WARNING}

	# echo ""
	# head -n2 tests/test6.11.lp
	# @-clingo ${DOMAIN} tests/test6.11.lp ${HIDE_WARNING}

	# echo ""
	# head -n2 tests/test6.12.lp
	# @-clingo ${DOMAIN} tests/test6.12.lp ${HIDE_WARNING}

	# echo ""
	# head -n2 tests/test6.13.lp
	# @-clingo ${DOMAIN} tests/test6.13.lp ${HIDE_WARNING}

	# echo ""
	# head -n2 tests/test6.14.lp
	# @-clingo ${DOMAIN} tests/test6.14.lp ${HIDE_WARNING}

	# echo ""
	# head -n2 tests/test6.15.lp
	# @-clingo ${DOMAIN} tests/test6.15.lp ${HIDE_WARNING}

	# echo ""
	# head -n2 tests/test6.16.lp
	# @-clingo ${DOMAIN} tests/test6.16.lp ${HIDE_WARNING}

	# echo ""
	# head -n2 tests/test6.17.lp
	# @-clingo ${DOMAIN} tests/test6.17.lp ${HIDE_WARNING}

	# echo ""
	# head -n2 tests/test6.18.lp
	# @-clingo ${DOMAIN} tests/test6.18.lp ${HIDE_WARNING}

	echo ""

.SILENT:
test7:

.SILENT:
test8:

.SILENT:
test9:
	echo $@
	head -n2 tests/test9.lp
	@-clingo ${DOMAIN} ${PLAN} ${INIT} tests/test9.lp ${HIDE_WARNING}
	echo ""

.SILENT:
test10:
	echo $@
	head -n2 tests/test10.lp
	@-clingo ${DOMAIN} ${PLAN} ${INIT} tests/test10.lp ${HIDE_WARNING}
	echo ""

# test other constraints
.SILENT:
test11:
	echo $@
	head -n2 tests/test11.lp
	@-clingo ${DOMAIN} tests/test11.lp ${HIDE_WARNING}
	echo ""

# test planning 
.SILENT:
test12:
	echo $@
	head -n2 tests/test12.lp
	@-clingo ${DOMAIN} ${PLAN} ${INIT} tests/test12.lp ${HIDE_WARNING}
	echo ""

.SILENT:
test13:
	echo $@
	head -n2 tests/test13.lp
	@-clingo ${DOMAIN} ${PLAN} ${INIT} tests/test13.lp ${HIDE_WARNING}
	echo ""
	
.SILENT:
test14:
	echo $@
	head -n2 tests/test14.lp
	@-clingo ${DOMAIN} ${PLAN} ${INIT} tests/test14.lp ${HIDE_WARNING}
	echo ""

.SILENT:
test15:
	echo $@
	head -n2 tests/test15.lp
	@-clingo ${DOMAIN} ${PLAN} ${INIT} tests/test15.lp ${HIDE_WARNING}
	echo ""
.SILENT:
test16:
	echo $@
	head -n2 tests/test16.lp
	@-clingo ${DOMAIN} tests/test16.lp ${HIDE_WARNING}
	echo ""
.SILENT:
test17:
	echo $@
	head -n2 tests/test17.lp
	@-java -jar cps/cli.jar cps/cps-original.owl tests/test.owl cps/cps-reasoner.lp tests/test17.lp --asp-options ${HIDE_WARNING}
	echo ""
.SILENT:
test18:
	echo $@
	head -n2 tests/test18.lp
	@-java -jar cps/cli.jar ${DOMAIN} tests/test.owl cps/cps-original.owl tests/test18.lp cps/cps-reasoner.lp --asp-options ${HIDE_WARNING}
	echo ""

.SILENT:
test19:
	echo $@
	head -n2 tests/test19.lp
	@-java -jar cps/cli.jar ${DOMAIN} tests/test19.lp --asp-options ${HIDE_WARNING}
	echo ""

.SILENT:
test20:
	echo $@
	head -n2 tests/test20.lp
	@-java -jar cps/cli.jar ${DOMAIN} tests/test20.lp --asp-options ${HIDE_WARNING}
	echo ""

.SILENT:
test21:
	echo $@
	head -n2 tests/test21.lp
	@-java -jar cps/cli.jar ${DOMAIN} tests/test21.lp --asp-options ${HIDE_WARNING}
	echo ""