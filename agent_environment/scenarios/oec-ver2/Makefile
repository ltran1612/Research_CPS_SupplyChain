DOMAIN = general/domain.lp 
INIT = general/init.lp
PLAN = general/plan.lp
HIDE_WARNING = -q2,2,2 --warn no-atom-undefined -V0
all: test1 test2 test3 test4 test5 test6 test7 test8 test9 test10 test11 test12 test13 test14

.SILENT:
test1:
	echo $@
	echo "->satisfaction."
	@-clingo ${DOMAIN} ${INIT} tests/test1.lp  ${HIDE_WARNING}
	echo ""

.SILENT:
test2:
	echo $@
	echo "->satisfaction."
	@-clingo ${DOMAIN} tests/test2.lp   ${HIDE_WARNING}
	echo ""

.SILENT:
test3:
	echo $@
	echo "->satisfaction."
	@-clingo ${DOMAIN} ${INIT} tests/test3.lp  ${HIDE_WARNING}
	echo ""

.SILENT:
test4:
	echo $@
	echo "->satisfaction."
	@-clingo ${DOMAIN} tests/test4.lp ${HIDE_WARNING}
	echo ""

.SILENT:
test5:
	echo $@
	echo "->satisfaction."
	@-clingo ${DOMAIN} tests/test5.lp ${HIDE_WARNING}
	echo ""
	
.SILENT:
test6:
	echo $@
	echo "->satisfaction."
	@-clingo ${DOMAIN} tests/test6.lp ${HIDE_WARNING}
	echo ""
# Test the above but with quality	
.SILENT:
test7:
	echo $@
	echo "->satisfaction."
	@-clingo ${DOMAIN} ${INIT} tests/test7.lp ${HIDE_WARNING}
	echo ""

.SILENT:
test8:
	echo $@
	echo "->satisfaction."
	@-clingo ${DOMAIN} tests/test8.lp   ${HIDE_WARNING}
	echo ""

.SILENT:
test9:
	echo $@
	echo "->satisfaction."
	@-clingo ${DOMAIN} ${INIT} tests/test9.lp  ${HIDE_WARNING}
	echo ""

.SILENT:
test10:
	echo $@
	echo "->satisfaction."
	@-clingo ${DOMAIN} tests/test10.lp ${HIDE_WARNING}
	echo ""

# test other constraints
.SILENT:
test11:
	echo $@
	echo "->unsatisfaction."
	@-clingo ${DOMAIN} tests/test11.lp ${HIDE_WARNING}
	echo ""

# test planning 
.SILENT:
test12:
	echo $@
	echo "->satisfaction."
	@-clingo ${DOMAIN} ${PLAN} ${INIT} tests/test12.lp ${HIDE_WARNING}
	echo ""

.SILENT:
test13:
	echo $@
	echo "->satisfaction."
	@-clingo ${DOMAIN} ${PLAN} ${INIT} tests/test13.lp ${HIDE_WARNING}
	echo ""
	
.SILENT:
test14:
	echo $@
	echo "->satisfaction."
	@-clingo ${DOMAIN} ${PLAN} ${INIT} tests/test14.lp ${HIDE_WARNING}
	echo ""