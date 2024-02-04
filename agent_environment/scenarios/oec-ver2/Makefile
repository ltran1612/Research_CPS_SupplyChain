DOMAIN = general/domain.lp 
INIT = general/init.lp
HIDE_WARNING = --warn no-atom-undefined
all: test1 test2 test3

test1:
	clingo ${DOMAIN} ${INIT} tests/test1.lp  ${HIDE_WARNING}

test2:
	clingo ${DOMAIN} tests/test2.lp   ${HIDE_WARNING}

test3:
	clingo ${DOMAIN} ${INIT} tests/test3.lp  ${HIDE_WARNING}

test4:
	clingo ${DOMAIN} tests/test4.lp ${HIDE_WARNING}
