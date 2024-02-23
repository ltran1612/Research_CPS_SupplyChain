% test 8 - test deliver 
% test state
deliver_item(wood, Quality) :- quality(Quality).
time(0..10).
quality(1..10).
hold(available_item(wood, 201, 1), 0).
hold(delivered(wood, 0, 1), 0).

% test condition
% test dynamic law 
occur(deliver(wood, 100, 1), 1).
:- not hold(available_item(wood, 201, 1), 1). 
:- not hold(available_item(wood, 101, 1), 2). 
:- not hold(delivered(wood, 0, 1), 1). 
:- not hold(delivered(wood, 100, 1), 2). 
%
occur(deliver(wood, 100, 1), 5).
:- not hold(available_item(wood, 101, 1), 5). 
:- not hold(available_item(wood, 1, 1), 6). 
:- not hold(delivered(wood, 100, 1), 5). 
:- not hold(delivered(wood, 200, 1), 6). 

% inertial rules
:- not hold(available_item(wood, 1, 1), 7..10). 
:- hold(available_item(wood, 201, 1), 7..10). 
:- hold(available_item(wood, 201, 2), 7..10). 
:- hold(available_item(wood, 100, 1), 7..10). 
:- hold(available_item(wood, 101, 1), 7..10). 
