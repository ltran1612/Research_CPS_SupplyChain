% test 4 - test pay money  - normal case, edge case. 
% expect satisfaction.
% test state
time(0..10).
hold(available_funds, (test, (100,)), 0).
hold(total_sent_payment, (test, (agent1, the_item, 0)), 0).
hold(total_sent_payment, (test, (agent2, the_service, 0)), 0).
pay_item(test, agent1, the_item).
pay_item(test, agent2, the_service).
number(50).
number(1).
number(48).

% #show hold/3.
% #show operation/4.
% #show paying_reason/3.
% test condition
% test dynamic law 
% edge case 1 
occur(pay, (test, (agent1, the_item, 50)), 1).
:- not hold(available_funds, (test, (100,)), 1).
:- not hold(available_funds, (test, (50,)), 2).
:- not hold(total_sent_payment, (test, (agent1, the_item, 50)), 2).

% normal case 
occur(pay, (test, (agent1, the_item, 48)), 5).
:- not hold(available_funds, (test, (50,)), 5).
:- not hold(available_funds, (test, (2,)), 6).
:- not hold(total_sent_payment, (test, (agent1, the_item, 98)), 6).

% % second agent 
occur(pay, (test, (agent2, the_service, 1)), 9).
:- not hold(available_funds, (test, (2,)), 9).
:- not hold(available_funds, (test, (1,)), 10).
:- not hold(total_sent_payment, (test, (agent1, the_item, 98)), 9).
:- not hold(total_sent_payment, (test, (agent2, the_service, 0)), 0..9).
:- not hold(total_sent_payment, (test, (agent2, the_service, 1)), 10).
% % pay the agent should not affect the other payment
:- not hold(total_sent_payment, (test, (agent1, the_item, 98)), 10).

% % edge case 2
occur(pay, (test, (agent1, the_item, 1)), 10).
:- not hold(available_funds, (test, (1,)), 10).
% % nothing happens at time 11 since we do not want to calcualte it
:- hold(available_funds, (test, (_,)), 11).
:- hold(total_sent_payment, (test, (agent1, the_item, _)), 11).

% % test inertial rules
:- not hold(available_funds, (test, (2,)), 6..9).
:- not hold(total_sent_payment, (test, (agent1, the_item, 98)), 6..9).
% 
:- not hold(sent_payment, (test, (agent1, 1, the_item, 50)), 2..10).
:- not hold(sent_payment, (test, (agent1, 5, the_item, 48)), 6..10).
:- not hold(sent_payment, (test, (agent2, 9, the_service, 1)), 10).