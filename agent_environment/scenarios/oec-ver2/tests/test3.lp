% test 3 - test produce + deliver
% expect satisfaction
% test state
% expect no sati
produce_item(wood).
deliver_item(agent1, wood).
time(0..10).

% test condition
% test initial state
:- not hold(available_item(wood, 0), 0). 

% test dynamic law 
occur(produce(wood, 100), 1).
:- not hold(available_item(wood, 0), 1). 
:- not hold(available_item(wood, 100), 2). 
:- not hold(produced(wood, 100), 2). 
:- hold(produced(wood, 0), 2). 
:- not hold(delivered(agent1, wood, 0), 2). 
%
occur(deliver(agent1, wood, 100), 2).
:- not hold(available_item(wood, 100), 2). 
:- not hold(available_item(wood, 0), 3). 
:- not hold(delivered(agent1, wood, 0), 2). 
:- not hold(delivered(agent1, wood, 100), 3). 
:- hold(delivered(agent1, wood, 0), 3..5). 
:- hold(delivered(agent1, wood, 101), 3..5). 
:- hold(produced(wood, 0), 3..5). 
:- not hold(produced(wood, 100), 3..5). 
%
occur(produce(wood, 100), 5).
:- not hold(available_item(wood, 0), 5). 
:- not hold(available_item(wood, 100), 6). 
:- not hold(produced(wood, 200), 6). 
:- hold(produced(wood, 100), 6). 

% test inertial rules
:- not hold(produced(wood, 200), 7..10). 
:- not hold(delivered(agent1, wood, 100), 4..10). 