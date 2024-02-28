% test 1 - test produce
% test state
% expect no sati
produce_item(wood).
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
:- hold(produced(wood, 200), 2). 
%
occur(produce(wood, 100), 5).
:- not hold(available_item(wood, 100), 5). 
:- not hold(available_item(wood, 200), 6). 
:- not hold(produced(wood, 200), 6). 
:- hold(produced(wood, 0), 6). 
:- hold(produced(wood, 100), 6). 

% test inertial rules
:- not hold(produced(wood, 200), 7..10). 
:- not hold(produced(wood, 100), 2..4). 
:- hold(produced(wood, 0), 7..10). 
:- hold(produced(wood, 100), 7..10). 