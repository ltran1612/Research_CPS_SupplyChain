% test 3 - test produce + deliver with quality
% expect satisfaction
% test state
% expect no sati
produce_item(test, wood, 1..10).
deliver_item(test, agent1, wood, 1..10).
time(0..10).
number(100).

% test condition
% test initial state
:- not hold(available_quality_item, (test, (wood, 1..10, 0)), 0). 

% test dynamic law 
occur(produce_quality, (test, wood, 1, 100), 1).
:- not hold(available_quality_item, (test, (wood, 1, 0)), 1). 
:- not hold(available_quality_item, (test, (wood, 1, 100)), 2). 
:- not hold(total_produced_quality, (test, (wood, 1, 100)), 2). 
:- hold(total_produced_quality, (test, (wood, 1, 0)), 2). 
:- not hold(total_delivered_quality, (test, (agent1, wood, 1, 0)), 2). 
%
occur(deliver_quality, (test, agent1, wood, 1, 100), 2).
:- not hold(available_quality_item, (test, (wood, 1, 100)), 2). 
:- not hold(available_quality_item, (test, (wood, 1, 0)), 3). 
:- not hold(total_delivered_quality, (test, (agent1, wood, 1, 0)), 2). 
:- not hold(total_delivered_quality, (test, (agent1, wood, 1, 100)), 3). 
:- hold(total_delivered_quality, (test, (agent1, wood, 1, 0)), 3..5). 
:- hold(total_delivered_quality, (test, (agent1, wood, 1, 101)), 3..5). 
:- not hold(total_produced_quality, (test, (wood, 1, 100)), 2). 
:- hold(total_produced_quality, (test, (wood, 1, 0)), 3..5). 
:- not hold(total_produced_quality, (test, (wood, 1, 100)), 3..5). 
% %
occur(produce_quality, (test, wood, 1, 100), 5).
:- not hold(available_quality_item, (test, (wood, 1, 0)), 5). 
:- not hold(available_quality_item, (test, (wood, 1, 100)), 6). 
:- not hold(total_produced_quality, (test, (wood, 1, 200)), 6). 
:- hold(total_produced_quality, (test, (wood, 1, 100)), 6). 

% % test inertial rules
:- not hold(total_produced_quality, (test, (wood, 1, 200)), 7..10). 
:- not hold(total_delivered_quality, (test, (agent1, wood, 1, 100)), 4..10). 