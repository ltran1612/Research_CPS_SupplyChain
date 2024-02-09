% test case 12 - test planning with produce
time(0..10).
produce_item(apple).
number(500).
:- not hold(available_item(apple, 1000), 10). 
:- not hold(available_item(apple, 500), 5). 
:- hold(available_item(apple, 1000), 5). 