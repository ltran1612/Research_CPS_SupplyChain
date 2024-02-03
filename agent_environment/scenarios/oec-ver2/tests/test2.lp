% test 2 - test deliver 
% test state
deliver_item(wood).
time(0..10).
hold(available_item(wood, 201), 0).

% test condition
% test dynamic law 
occur(deliver(wood, 100), 1).
:- not hold(available_item(wood, 201), 1). 
:- not hold(available_item(wood, 101), 2). 
%
occur(deliver(wood, 100), 5).
:- not hold(available_item(wood, 101), 5). 
:- not hold(available_item(wood, 1), 6). 