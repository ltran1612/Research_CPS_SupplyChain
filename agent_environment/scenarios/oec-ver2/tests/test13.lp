% test case 13 - test planning with produce_item, deliver_item 
time(0..10).
produce_item(apple).
deliver_item(apple).
deliver_agent(agent1, apple).
number(500).
:- not hold(available_item(apple, 500), 2). 
:- not hold(delivered(apple, 500), 3). 
:- not hold(delivered(apple, 1000), 10). 
:- hold(delivered(apple, 1000), 1). 