% test 2 - test deliver with quality - normal and edge case
% expect satisfaction
% test state
deliver_item(test, agent1, wood, 1..10).
deliver_item(test, agent2, steel, 1..10).
time(0..10).
number(100).
hold(available_quality_item, (test, (wood, 1..10, 201)), 0).
hold(total_delivered_quality, (test, (agent1, wood, 1..10, 0)), 0).
hold(available_quality_item, (test, (steel, 1..10, 201)), 0).
hold(totla_delivered_quality, (test, (agent2, steel, 1..10, 0)), 0).

% test condition
% test dynamic law 
% edge case
occur(deliver_quality, (test, (agent1, wood, 1, 100)), 1).
:- not hold(available_quality_item, (test, (wood, 1, 201)), 1). 
:- not hold(available_quality_item, (test, (wood, 1, 101)), 2). 
% :- not hold(delivered(agent1, wood, 0, 1), 1). 
% :- not hold(delivered(agent1, wood, 100, 1), 2). 
% :- hold(delivered(agent1, wood, 0, 1), 2). 

% % middle case
% occur(deliver(agent1, wood, 1, 1), 5).
% :- not hold(available_item(wood, 101, 1), 5). 
% :- not hold(available_item(wood, 100, 1), 6). 
% :- not hold(delivered(agent1, wood, 100, 1), 5). 
% :- not hold(delivered(agent1, wood, 101, 1), 6). 
% :- hold(delivered(agent1, wood, 100, 1), 6). 
% :- hold(delivered(agent1, wood, 1, 1), 6). 
% :- hold(delivered(agent1, wood, 0, 1), 6). 

% % middle case
% occur(deliver(agent1, wood, 1, 1), 7).
% :- not hold(available_item(wood, 100, 1), 7). 
% :- not hold(available_item(wood, 99, 1), 8). 
% :- not hold(delivered(agent1, wood, 101, 1), 7). 
% :- not hold(delivered(agent1, wood, 102, 1), 8). 
% :- hold(delivered(agent1, wood, 100, 1), 8). 
% :- hold(delivered(agent1, wood, 101, 1), 8). 
% :- hold(delivered(agent1, wood, 1, 1), 8). 
% :- hold(delivered(agent1, wood, 0, 1), 8). 

% % edge case
% occur(deliver(agent1, wood, 1, 1), 10).
% :- not hold(available_item(wood, 99, 1), 10). 
% :- not hold(delivered(agent1, wood, 102, 1), 10). 
% % time ends at 11
% :- hold(delivered(agent1, wood, _, 1), 11). 
% :- hold(available_item(wood, _, 1), 11). 

% % % inertial rules
% :- not hold(available_item(wood, 101, 1), 2..5). 
% :- not hold(available_item(wood, 100, 1), 6..7). 
% :- not hold(available_item(wood, 99, 1), 8..10). 
% :- hold(available_item(wood, 100, 1), 8..10). 
% :- hold(available_item(wood, 101, 1), 6..10). 
% %
% :- not hold(delivered(agent1, wood, 100, 1), 2..5). 
% :- not hold(delivered(agent1, wood, 101, 1), 6..7). 
% :- not hold(delivered(agent1, wood, 102, 1), 8..10). 
% :- hold(delivered(agent1, wood, 0, 1), 3..10). 
% :- hold(delivered(agent1, wood, 100, 1), 6..10). 
% %
% :- hold(available_item(wood, 100, 2..10), 1..10). 
% :- hold(available_item(wood, 101, 2..10), 1..10). 
% :- hold(delivered(agent1, wood, 1, 2..10), 1..10). 
% :- hold(delivered(agent1, wood, 100, 2..10), 1..10). 

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % test steel  only
% % test condition
% % test dynamic law 
% % edge case
% occur(deliver(agent2, steel, 100, 1), 0).
% :- not hold(available_item(steel, 201, 1), 0). 
% :- not hold(available_item(steel, 101, 1), 1). 
% :- not hold(delivered(agent2, steel, 0, 1), 0). 
% :- not hold(delivered(agent2, steel, 100, 1), 1). 
% :- hold(delivered(agent2, steel, 0, 1), 1). 
% % normal case
% occur(deliver(agent2, steel, 1, 1), 6).
% :- not hold(available_item(steel, 101, 1), 6). 
% :- not hold(available_item(steel, 100, 1), 7). 
% :- not hold(delivered(agent2, steel, 100, 1), 6). 
% :- not hold(delivered(agent2, steel, 101, 1), 7). 
% :- hold(delivered(agent2, steel, 100, 1), 7). 
% :- hold(delivered(agent2, steel, 1, 1), 7). 
% :- hold(delivered(agent2, steel, 0, 1), 7). 

% % inertial rules
% :- not hold(available_item(steel, 100, 1), 7..10).
% :- not hold(delivered(agent2, steel, 101, 1), 7..10).

% % agent and item cannot mix and match with other agent and items.
% :- hold(delivered(agent2, wood, _, _), 0..10). 
% :- hold(delivered(agent1, steel, _, _), 0..10). 
% % agent with quality will not create agent with no quality
% :- hold(delivered(agent1, wood), 0..10). 
% :- hold(delivered(agent2, steel), 0..10). 
% % agent with quality will not affect the others agent with quality
% :- hold(delivered(agent1, wood, Amount, 2..10), 0..10), not Amount == 0. 
% :- hold(available_item(wood, Amount, 2..10), 0..10), not Amount == 201. 