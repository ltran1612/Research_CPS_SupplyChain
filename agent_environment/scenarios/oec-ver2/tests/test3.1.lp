% test 3 - test produce + deliver with quality
% expect satisfaction
% test state
% expect no sati
produce_item(wood, 1..10).
deliver_item(agent1, wood, 1..10).
time(0..10).

% test condition
% test initial state
:- not hold(available_item(wood, 0, 1..10), 0). 

% test dynamic law 
occur(produce(wood, 100, 1), 1).
:- not hold(available_item(wood, 0, 1), 1). 
:- not hold(available_item(wood, 100, 1), 2). 
:- not hold(produced(wood, 100, 1), 2). 
:- hold(produced(wood, 0, 1), 2). 
:- not hold(delivered(agent1, wood, 0, 1), 2). 
%
occur(deliver(agent1, wood, 100, 1), 2).
:- not hold(available_item(wood, 100, 1), 2). 
:- not hold(available_item(wood, 0, 1), 3). 
:- not hold(delivered(agent1, wood, 0, 1), 2). 
:- not hold(delivered(agent1, wood, 100, 1), 3). 
:- hold(delivered(agent1, wood, 0, 1), 3..5). 
:- hold(delivered(agent1, wood, 101, 1), 3..5). 
:- hold(produced(wood, 0, 1), 3..5). 
:- not hold(produced(wood, 100, 1), 3..5). 
%
occur(produce(wood, 100, 1), 5).
:- not hold(available_item(wood, 0, 1), 5). 
:- not hold(available_item(wood, 100, 1), 6). 
:- not hold(produced(wood, 200, 1), 6). 
:- hold(produced(wood, 100, 1), 6). 

% test inertial rules
:- not hold(produced(wood, 200, 1), 7..10). 
:- not hold(delivered(agent1, wood, 100, 1), 4..10). 