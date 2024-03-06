% test 4 - test pay money 
% test state
% expect satisfaction.
time(0..10).
hold(available_funds(100), 0).
pay_item(agent1, the_item).
recv_agent(1..2).

% test condition
% test dynamic law 
occur(pay(agent1, the_item, 50), 1).
:- not hold(available_funds(100), 1).
:- not hold(available_funds(50), 2).
%
occur(pay(agent1, the_item, 50), 3).
:- not hold(available_funds(50), 3).
:- not hold(available_funds(0), 4).
% test inertial rules
:- not hold(available_funds(0), 5..10). 