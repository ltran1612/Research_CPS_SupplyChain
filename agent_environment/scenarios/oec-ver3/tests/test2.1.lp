% test 2 - test deliver with quality - normal and edge case
% expect satisfaction
% test state
deliver_item(test, agent1, wood, 1..10).
deliver_item(test, agent2, steel, 1..10).
time(0..10).
number(100).
number(1).
hold(available_quality_item, (test, (wood, 1..10, 201)), 0).
hold(available_quality_item, (test, (steel, 1..10, 201)), 0).
hold(total_delivered_quality, (test, (agent1, wood, 1..10, 0)), 0).
hold(total_delivered_quality, (test, (agent2, steel, 1..10, 0)), 0).

% test condition
% test dynamic law 
% edge case
occur(deliver_quality, (test, agent1, wood, 1, 100), 1).
:- not hold(available_quality_item, (test, (wood, 1, 201)), 1). 
:- not hold(available_quality_item, (test, (wood, 1, 101)), 2). 
:- not hold(total_delivered_quality, (test, (agent1, wood, 1, 0)), 1).
:- not hold(total_delivered_quality, (test, (agent1, wood, 1, 100)), 2).
:- hold(total_delivered_quality, (test, (agent1, wood, 1, 0)), 2).

% % middle case
occur(deliver_quality, (test, agent1, wood, 1, 1), 5).
:- not hold(available_quality_item, (test, (wood, 1, 101)), 5). 
:- not hold(available_quality_item, (test, (wood, 1, 100)), 6). 
:- not hold(total_delivered_quality, (test, (agent1, wood, 1, 100)), 5).
:- not hold(total_delivered_quality, (test, (agent1, wood, 1, 101)), 6).
:- hold(total_delivered_quality, (test, (agent1, wood, 1, 100)), 6).
:- hold(total_delivered_quality, (test, (agent1, wood, 1, 1)), 6).
:- hold(total_delivered_quality, (test, (agent1, wood, 1, 0)), 6).

% % middle case
occur(deliver_quality, (test, agent1, wood, 1, 1), 7).
:- not hold(available_quality_item, (test, (wood, 1, 100)), 7). 
:- not hold(available_quality_item, (test, (wood, 1, 99)), 8). 
:- not hold(total_delivered_quality, (test, (agent1, wood, 1, 101)), 7).
:- not hold(total_delivered_quality, (test, (agent1, wood, 1, 102)), 8).
:- hold(total_delivered_quality, (test, (agent1, wood, 1, 100)), 8).
:- hold(total_delivered_quality, (test, (agent1, wood, 1, 101)), 8).
:- hold(total_delivered_quality, (test, (agent1, wood, 1, 1)), 8).
:- hold(total_delivered_quality, (test, (agent1, wood, 1, 0)), 8).

% % edge case
occur(deliver_quality, (test, agent1, wood, 1, 1), 10).
:- not hold(available_quality_item, (test, (wood, 1, 99)), 10). 
:- not hold(total_delivered_quality, (test, (agent1, wood, 1, 102)), 10).
:- hold(total_delivered_quality, (test, (agent1, wood, 1, _)), 11).
:- hold(total_delivered_quality, (test, (agent1, wood, 1, _)), 11).

% % % inertial rules
:- not hold(available_quality_item, (test, (wood, 1, 101)), 2..5). 
:- not hold(available_quality_item, (test, (wood, 1, 100)), 6..7). 
:- not hold(available_quality_item, (test, (wood, 1, 99)), 8..10). 
:- not hold(total_delivered_quality, (test, (agent1, wood, 1, 101)), 6..7).
:- hold(available_quality_item, (test, (wood, 1, 100)), 8..10). 
:- hold(available_quality_item, (test, (wood, 1, 101)), 6..10). 
% %
:- not hold(total_delivered_quality, (test, (agent1, wood, 1, 100)), 2..5).
:- not hold(total_delivered_quality, (test, (agent1, wood, 1, 101)), 6..7).
:- not hold(total_delivered_quality, (test, (agent1, wood, 1, 102)), 8..10).
:- hold(total_delivered_quality, (test, (agent1, wood, 1, 0)), 3..10).
:- hold(total_delivered_quality, (test, (agent1, wood, 1, 100)), 6..10).
% %
:- hold(total_delivered_quality, (test, (agent1, wood, 2..10, 100)), 1..10).
:- hold(total_delivered_quality, (test, (agent1, wood, 2..10, 1)), 1..10).
:- hold(available_quality_item, (test, (wood, 2..10, 100)), 1..10). 
:- hold(available_quality_item, (test, (wood, 2..10, 101)), 1..10). 

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % test steel  only
% % test condition
% % test dynamic law 
% % edge case
% occur(deliver(agent2, steel, 100, 1), 0).
occur(deliver_quality, (test, agent2, steel, 1, 100), 0).
% #show operation/4.
% #show changed/6.
% #show causes/6.
% #show hold/3.
% #show require/3.
% #show inertial/4.
:- not hold(available_quality_item, (test, (steel, 1, 201)), 0). 
:- not hold(available_quality_item, (test, (steel, 1, 101)), 1). 
:- not hold(total_delivered_quality, (test, (agent2, steel, 1, 0)), 0). 
:- not hold(total_delivered_quality, (test, (agent2, steel, 1, 100)), 1). 
:- hold(total_delivered_quality, (test, (agent2, steel, 1, 0)), 1). 
% % normal case
% occur(deliver(agent2, steel, 1, 1), 6).
occur(deliver_quality, (test, agent2, steel, 1, 1), 6).
:- not hold(available_quality_item, (test, (steel, 1, 101)), 6). 
:- not hold(available_quality_item, (test, (steel, 1, 100)), 7). 
:- not hold(total_delivered_quality, (test, (agent2, steel, 1, 100)), 6). 
:- not hold(total_delivered_quality, (test, (agent2, steel, 1, 101)), 7). 
:- hold(total_delivered_quality, (test, (agent2, steel, 1, 0)), 7). 
:- hold(total_delivered_quality, (test, (agent2, steel, 1, 1)), 1). 

% % inertial rules
:- not hold(available_quality_item, (test, (steel, 1, 100)), 7..10). 
:- not hold(total_delivered_quality, (test, (agent2, steel, 1, 101)), 7..10). 

% % agent and item cannot mix and match with other agent and items.
:- hold(total_delivered_quality, (test, (agent2, wood, _, _)), 0..10). 
:- hold(total_delivered_quality, (test, (agent1, steel, _, _)), 0..10). 
% % agent with quality will not create agent with no quality
:- hold(total_delivered_quality, (test, (agent2, wood, _)), 0..10). 
:- hold(total_delivered_quality, (test, (agent1, steel, _)), 0..10). 
% % agent with quality will not affect the others agent with quality
:- hold(total_delivered_quality, (test, (agent2, wood, 2..10, Amount)), 0..10), not Amount == 0. 
:- hold(available_quality_item, (test, (agent2, wood, 2..10, Amount)), 0..10), not Amount == 201. 

% test delivered_quality to keep track of delivered stuffs. 
:- not hold(delivered_quality, (test, (agent1, 1, wood, 1, 100)), 2..10).
:- not hold(delivered_quality, (test, (agent1, 5, wood, 1, 1)), 6..10).
:- not hold(delivered_quality, (test, (agent1, 7, wood, 1, 1)), 8..10).
:- not hold(delivered_quality, (test, (agent2, 0, steel, 1, 100)), 1..10).
:- not hold(delivered_quality, (test, (agent2, 6, steel, 1, 1)), 8..10).