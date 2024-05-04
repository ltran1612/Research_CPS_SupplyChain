% test 2 - test deliver with no quality - normal and edge case
% expect satisfaction
% test state
deliver_item(agent1, wood).
deliver_item(agent2, steel).
time(0..10).
hold(available_item(wood, 201), 0).
hold(available_item(steel, 201), 0).
hold(delivered(agent1, wood, 0), 0).
hold(delivered(agent2, steel, 0), 0).

% test wood only
% test condition
% test dynamic law 
% edge case
occur(deliver(agent1, wood, 100), 1).
:- not hold(available_item(wood, 201), 1). 
:- not hold(available_item(wood, 101), 2). 
:- not hold(delivered(agent1, wood, 0), 1). 
:- not hold(delivered(agent1, wood, 100), 2). 
:- hold(delivered(agent1, wood, 0), 2). 

% middle case
occur(deliver(agent1, wood, 1), 5).
:- not hold(available_item(wood, 101), 5). 
:- not hold(available_item(wood, 100), 6). 
:- not hold(delivered(agent1, wood, 100), 5). 
:- not hold(delivered(agent1, wood, 101), 6). 
:- hold(delivered(agent1, wood, 100), 6). 
:- hold(delivered(agent1, wood, 1), 6). 
:- hold(delivered(agent1, wood, 0), 6). 

% middle case
occur(deliver(agent1, wood, 1), 7).
:- not hold(available_item(wood, 100), 7). 
:- not hold(available_item(wood, 99), 8). 
:- not hold(delivered(agent1, wood, 101), 7). 
:- not hold(delivered(agent1, wood, 102), 8). 
:- hold(delivered(agent1, wood, 100), 8). 
:- hold(delivered(agent1, wood, 101), 8). 
:- hold(delivered(agent1, wood, 1), 8). 
:- hold(delivered(agent1, wood, 0), 8). 

% edge case
occur(deliver(agent1, wood, 1), 10).
:- not hold(available_item(wood, 99), 10). 
:- not hold(delivered(agent1, wood, 102), 10). 
% time ends at 11
:- hold(delivered(agent1, wood, _), 11). 
:- hold(available_item(wood, _), 11). 

% % inertial rules
:- not hold(available_item(wood, 101), 2..5). 
:- not hold(available_item(wood, 100), 6..7). 
:- not hold(available_item(wood, 99), 8..10). 
:- hold(available_item(wood, 100), 8..10). 
:- hold(available_item(wood, 101), 6..10). 
%
:- not hold(delivered(agent1, wood, 100), 2..5). 
:- not hold(delivered(agent1, wood, 101), 6..7). 
:- not hold(delivered(agent1, wood, 102), 8..10). 
:- hold(delivered(agent1, wood, 0), 3..10). 
:- hold(delivered(agent1, wood, 100), 6..10). 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% test steel  only
% test condition
% test dynamic law 
% edge case
occur(deliver(agent2, steel, 100), 0).
:- not hold(available_item(steel, 201), 0). 
:- not hold(available_item(steel, 101), 1). 
:- not hold(delivered(agent2, steel, 0), 0). 
:- not hold(delivered(agent2, steel, 100), 1). 
:- hold(delivered(agent2, steel, 0), 1). 
% normal case
occur(deliver(agent2, steel, 1), 6).
:- not hold(available_item(steel, 101), 6). 
:- not hold(available_item(steel, 100), 7). 
:- not hold(delivered(agent2, steel, 100), 6). 
:- not hold(delivered(agent2, steel, 101), 7). 
:- hold(delivered(agent2, steel, 100), 7). 
:- hold(delivered(agent2, steel, 1), 7). 
:- hold(delivered(agent2, steel, 0), 7). 

% inertial rules
:- not hold(available_item(steel, 100), 7..10).
:- not hold(delivered(agent2, steel, 101), 7..10).

% agent and item cannot mix and match with other agent and items.
:- hold(delivered(agent2, wood, _), 0..10). 
:- hold(delivered(agent1, steel, _), 0..10). 