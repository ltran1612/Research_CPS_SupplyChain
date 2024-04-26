% test 4 - test pay money  - test error case of not having enough money
% expect satisfaction.
% test state
time(0..10).
hold(available_funds, (test, (100,)), 0).
hold(total_sent_payment, (test, (agent1, the_item, 0)), 0).
hold(total_sent_payment, (test, (agent2, the_service, 0)), 0).
inertial(test, available_funds, foo, foo).
inertial(test, total_sent_payment, foo, foo).
pay_item(test, agent1, the_item).
pay_item(test, agent2, the_service).

% test condition
% test dynamic law 
% edge case 1 
occur(pay, (test, (agent1, the_item, 101)), 1).
:- not hold(available_funds, (test, (100,)), 2..10).
:- not hold(total_sent_payment, (test, (agent1, the_item, 0)), 2..10).
:- not hold(total_sent_payment, (test, (agent2, the_service, 0)), 2..10).