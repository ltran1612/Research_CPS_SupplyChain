% test 4 - test pay money  - test spending all money 
% expect satisfaction.
% test state
time(0..10).
hold(available_funds, (test, (100,)), 0).
hold(total_sent_payment, (test, (agent1, the_item, 0)), 0).
hold(total_sent_payment, (test, (agent2, the_service, 0)), 0).
pay_item(test, agent1, the_item).
number(100).
pay_item(test, agent2, the_service).

% test condition
% test dynamic law 
% edge case 1 
occur(pay, (test, agent1, the_item, 100), 1).
:- not hold(available_funds, (test, (0,)), 2..10).
:- not hold(total_sent_payment, (test, (agent1, the_item, 100)), 2..10).