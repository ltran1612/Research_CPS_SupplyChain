% test 7 - test produce
% test state
% expect no sati
produce_item(wood).
time(0..10).
quality(1..2).

% test condition
% test initial state
:- not hold(available_item(wood, 0, 1), 0). 

% test dynamic law 
occur(produce(wood, 100, 1), 1).
:- not hold(available_item(wood, 0, 1), 1). 
:- not hold(available_item(wood, 100, 1), 2). 
:- not hold(produced(wood, 100, 1), 2). 
%
occur(produce(wood, 100, 1), 5).
:- not hold(available_item(wood, 100, 1), 5). 
:- not hold(available_item(wood, 200, 1), 6). 
:- not hold(produced(wood, 200, 1), 6). 

% % test inertial rules
:- not hold(produced(wood, 200, 1), 7..10). 
:- not hold(produced(wood, 100, 1), 2..4). 
:- hold(produced(wood, 0, 1), 7..10). 
:- hold(produced(wood, 100, 1), 7..10). 