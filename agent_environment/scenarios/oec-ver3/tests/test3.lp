% test 3 - test produce + deliver
% expect satisfaction
% test state
% expect no sati
produce_item(test, wood).
deliver_item(test, agent1, wood).
time(0..10).
number(100).

% test condition
% test initial state
:- not hold(available_item, (test, (wood, 0)), 0). 

% test dynamic law 
occur(produce, (test, (wood, 100)), 1).
:- not hold(available_item, (test, (wood, 0)), 1). 
:- not hold(available_item, (test, (wood, 100)), 2). 
:- not hold(total_produced, (test, (wood, 100)), 2). 
:- hold(total_produced, (test, (wood, 0)), 2). 
:- not hold(total_delivered, (test, (agent1, wood, 0)), 2). 
%
occur(deliver, (test, (agent1, wood, 100)), 2).
:- not hold(available_item, (test, (wood, 100)), 2). 
:- not hold(available_item, (test, (wood, 0)), 3). 
:- not hold(total_delivered, (test, (agent1, wood, 0)), 2). 
:- not hold(total_delivered, (test, (agent1, wood, 100)), 3). 
:- hold(total_delivered, (test, (agent1, wood, 0)), 3..5). 
:- hold(total_delivered, (test, (agent1, wood, 101)), 3..5). 
:- hold(total_produced, (test, (wood, 0)), 3..5). 
:- not hold(total_produced, (test, (wood, 100)), 3..5). 
% %
occur(produce, (test, (wood, 100)), 5).
:- not hold(available_item, (test, (wood, 0)), 5). 
:- not hold(available_item, (test, (wood, 100)), 6). 
:- not hold(total_produced, (test, (wood, 200)), 6). 
:- hold(total_produced, (test, (wood, 100)), 6). 

% % test inertial rules
:- not hold(total_produced, (test, (wood, 200)), 7..10). 
:- not hold(total_delivered, (test, (agent1, wood, 100)), 4..10). 