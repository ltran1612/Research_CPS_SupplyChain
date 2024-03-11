% test 4 - test pay money  - normal case, edge case. 
% expect satisfaction.
% test state
time(0..10).
hold(available_funds(100), 0).
hold(payment(agent1, sent, the_item, 0), 0).
hold(payment(agent2, sent, the_service, 0), 0).
pay_item(agent1, the_item).
pay_item(agent2, the_service).

% test condition
% test dynamic law 
% edge case 1 
occur(pay(agent1, the_item, 50), 1).
:- not hold(available_funds(100), 1).
:- not hold(available_funds(50), 2).
:- not hold(payment(agent1, sent, the_item, 50), 2).

% normal case 
occur(pay(agent1, the_item, 48), 5).
:- not hold(available_funds(50), 5).
:- not hold(available_funds(2), 6).
:- not hold(payment(agent1, sent, the_item, 98), 6).

% second agent 
occur(pay(agent2, the_service, 1), 9).
:- not hold(available_funds(2), 9).
:- not hold(available_funds(1), 10).
:- not hold(payment(agent1, sent, the_item, 98), 9).
:- not hold(payment(agent2, sent, the_service, 1), 10).
% pay the agent should not affect the other payment
:- not hold(payment(agent1, sent, the_item, 98), 10).

% edge case 2
occur(pay(agent1, the_item, 1), 10).
:- not hold(available_funds(1), 10).
% nothing happens at time 11 since we do not want to calcualte it
:- hold(available_funds(_), 11).
:- hold(payment(agent1, sent, _, the_item), 11).

% test inertial rules
:- not hold(available_funds(2), 6..9). 
:- not hold(payment(agent1, sent, the_item, 98), 6..9).