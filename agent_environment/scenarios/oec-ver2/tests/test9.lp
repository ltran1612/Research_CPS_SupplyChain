% test 9 - test produce + deliver
% test state
% expect no satisfaction
produce_item(wood, Quality) :- quality(Quality).
deliver_item(wood, Quality) :- quality(Quality).
quality(1..10).
time(0..10).

% test condition
% test initial state
:- not hold(available_item(wood, 0, 1), 0). 

% test dynamic law 
occur(produce(wood, 100, 1), 1).
:- not hold(available_item(wood, 0, 1), 1). 
:- not hold(available_item(wood, 100, 1), 2). 
:- not hold(produced(wood, 100, 1), 2). 
%
occur(deliver(wood, 100, 1), 2).
:- not hold(available_item(wood, 100, 1), 2). 
:- not hold(available_item(wood, 0, 1), 3). 
:- not hold(delivered(wood, 0, 1), 2). 
:- not hold(delivered(wood, 100, 1), 3). 
%
occur(produce(wood, 100, 1), 5).
:- not hold(available_item(wood, 0, 1), 5). 
:- not hold(available_item(wood, 100, 1), 6). 
:- not hold(produced(wood, 200, 1), 6). 

% test inertial rules
:- not hold(produced(wood, 200, 1), 7..10). 