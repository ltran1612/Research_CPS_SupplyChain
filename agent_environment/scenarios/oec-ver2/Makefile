DOMAIN = general/domain.lp 
INIT = general/init.lp
HIDE_WARNING = -q2,2,2 --warn no-atom-undefined -V0
all: test1 test2 test3 test4 test5 test6

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
