% test 2 - test deliver 
% test state
deliver_item(wood).
time(0..10).
hold(available_item(wood, 201), 0).
hold(delivered(wood, 0), 0).

% test condition
% test dynamic law 
occur(deliver(wood, 100), 1).
:- not hold(available_item(wood, 201), 1). 
:- not hold(available_item(wood, 101), 2). 
:- not hold(delivered(wood, 0), 1). 
:- not hold(delivered(wood, 100), 2). 
:- hold(delivered(wood, 0), 2). 
%
occur(deliver(wood, 100), 5).
:- not hold(available_item(wood, 101), 5). 
:- not hold(available_item(wood, 1), 6). 
:- not hold(delivered(wood, 100), 5). 
:- not hold(delivered(wood, 200), 6). 
:- hold(delivered(wood, 100), 6). 
:- hold(delivered(wood, 0), 6). 

% inertial rules
:- not hold(available_item(wood, 1), 7..10). 
:- hold(available_item(wood, 201), 7..10). 
:- hold(available_item(wood, 100), 7..10). 
:- hold(available_item(wood, 101), 7..10). 
