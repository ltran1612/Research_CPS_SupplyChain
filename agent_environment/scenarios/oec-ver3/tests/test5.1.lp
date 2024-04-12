% test 5 - test receiving money - error case - receive with no notification
% expect satisfaction 
% test state
time(0..10).
hold(available_funds, (test, (0,)), 0).
hold(total_received_payment, (test, (agent1, receiving_item, 0)), 0).
hold(total_received_payment, (test, (agent2, receiving_apple, 0)), 0).
receiving_reason(test, agent1, receiving_item).
number(50).
receiving_reason(test, agent2, receiving_apple).

% test condition
% test dynamic law 
% receive money 1
occur(receive_money, (test, agent1, 0, receiving_item, 50), 1).
:- not failed(receive_money, (test, agent1, 0, receiving_item, 50), 1).