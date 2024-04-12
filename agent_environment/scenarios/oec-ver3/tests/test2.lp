% test 2 - test deliver with no quality - normal and edge case
% expect satisfaction
% test state
deliver_item(test, agent1, wood).
deliver_item(test, agent2, steel).
time(0..10).
hold(available_item, (test, (wood, 201)), 0).
hold(available_item, (test, (steel, 201)), 0).
hold(total_delivered, (test, (agent1, wood, 0)), 0).
hold(total_delivered, (test, (agent2, steel, 0)), 0).
number(100).
number(1).

% test wood only
% test condition
% test dynamic law 
% edge case
occur(deliver, (test, (agent1, wood, 100)), 1).
% #show require/3.
% #show causes/6.
% #show possible/3.
% #show executable/4.
% #show operation/4.
% #show hold/3.
% #show satisfy_condition/4.
:- not hold(available_item, (test, (wood, 201)), 1). 
:- not hold(available_item, (test, (wood, 101)), 2). 
:- not hold(total_delivered, (test, (agent1, wood, 0)), 1). 
:- not hold(total_delivered, (test, (agent1, wood, 100)), 2). 
:- hold(total_delivered, (test, (agent1, wood, 0)), 2). 

% middle case
occur(deliver, (test, (agent1, wood, 1)), 5).
:- not hold(available_item, (test, (wood, 101)), 5). 
:- not hold(available_item, (test, (wood, 100)), 6). 
:- not hold(total_delivered, (test, (agent1, wood, 100)), 5). 
:- not hold(total_delivered, (test, (agent1, wood, 101)), 6). 
:- hold(total_delivered, (test, (agent1, wood, 100)), 6). 
:- hold(total_delivered, (test, (agent1, wood, 1)), 6). 
:- hold(total_delivered, (test, (agent1, wood, 0)), 6). 

% middle case
% occur(deliver(agent1, wood, 1), 7).
occur(deliver, (test, (agent1, wood, 1)), 7).
:- not hold(available_item, (test, (wood, 100)), 7). 
:- not hold(available_item, (test, (wood, 99)), 8). 
:- not hold(total_delivered, (test, (agent1, wood, 101)), 7). 
:- not hold(total_delivered, (test, (agent1, wood, 102)), 8). 
:- hold(total_delivered, (test, (agent1, wood, 100)), 8). 
:- hold(total_delivered, (test, (agent1, wood, 1)), 8). 
:- hold(total_delivered, (test, (agent1, wood, 0)), 8). 

% % edge case
occur(deliver, (test, (agent1, wood, 1)), 10).
:- not hold(available_item, (test, (wood, 99)), 10). 
:- not hold(total_delivered, (test, (agent1, wood, 102)), 10). 
:- hold(total_delivered, (test, (agent1, wood, _)), 11). 
:- hold(total_delivered, (test, (agent1, wood, _)), 11). 

% % % inertial rules
:- not hold(available_item, (test, (wood, 101)), 2..5). 
:- not hold(available_item, (test, (wood, 100)), 6..7). 
:- not hold(available_item, (test, (wood, 99)), 8..10). 
:- hold(available_item, (test, (wood, 100)), 8..10). 
:- hold(available_item, (test, (wood, 101)), 6..10). 
%
:- not hold(total_delivered, (test, (agent1, wood, 100)), 2..5). 
:- not hold(total_delivered, (test, (agent1, wood, 101)), 6..7). 
:- not hold(total_delivered, (test, (agent1, wood, 102)), 8..10). 
:- hold(total_delivered, (test, (agent1, wood, 0)), 3..10). 
:- hold(total_delivered, (test, (agent1, wood, 100)), 6..10). 

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % test steel  only
% % test condition
% % test dynamic law 
% % edge case
occur(deliver, (test, (agent2, steel, 100)), 0).
:- not hold(available_item, (test, (steel, 201)), 0). 
:- not hold(available_item, (test, (steel, 101)), 1). 
:- not hold(total_delivered, (test, (agent2, steel, 0)), 0). 
:- not hold(total_delivered, (test, (agent2, steel, 100)), 1). 
:- hold(total_delivered, (test, (agent2, steel, 0)), 1). 
% normal case
occur(deliver, (test, (agent2, steel, 1)), 6).
:- not hold(available_item, (test, (steel, 101)), 6). 
:- not hold(available_item, (test, (steel, 100)), 7). 
:- not hold(total_delivered, (test, (agent2, steel, 100)), 6). 
:- not hold(total_delivered, (test, (agent2, steel, 101)), 7). 
:- hold(total_delivered, (test, (agent2, steel, 100)), 7). 
:- hold(total_delivered, (test, (agent2, steel, 1)), 7). 
:- hold(total_delivered, (test, (agent2, steel, 0)), 7). 

% % inertial rules
:- not hold(available_item, (test, (steel, 100)), 7..10). 
:- not hold(total_delivered, (test, (agent2, steel, 101)), 7..10). 

% agent and item cannot mix and match with other agent and items.
:- hold(total_delivered, (test, (agent2, wood, _)), 7..10). 
:- hold(total_delivered, (test, (agent1, steel, _)), 7..10). 