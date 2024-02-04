% test 4 - test money 
% test state
% expect no sati
time(0..10).
hold(available_funds(100), 0).
pay_item(the_item).

% test condition
% test dynamic law 
occur(pay(the_item, 50), 1).
:- not hold(available_funds(100), 1).
:- not hold(available_funds(50), 2).
%
occur(pay(the_item, 50), 3).
:- not hold(available_funds(50), 3).
:- not hold(available_funds(0), 4).
% test inertial rules
:- not hold(available_funds(0), 5..10). 