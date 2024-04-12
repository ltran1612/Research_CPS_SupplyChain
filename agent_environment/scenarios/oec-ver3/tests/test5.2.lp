% test 5 - test receiving money - error case - have a different notification
% expect satisfaction 
% test state
time(0..10).
hold(available_funds, (test, (0,)), 0).
hold(total_received_payment, (test, (agent1, receiving_item, 0)), 0).
hold(total_received_payment, (test, (agent2, receiving_apple, 0)), 0).
receiving_reason(test, agent1, receiving_item).
receiving_reason(test, agent3, receiving_item).
receiving_reason(test, agent2, receiving_apple).
pay_item(agent3, test, receiving_item).
number(50).

% test condition
% test dynamic law 
% receive money 1
hold(sent_payment, (agent3, (test, 0, receiving_item, 50)), 0).
occur(receive_money, (test, agent1, 0, receiving_item, 50), 1).
:- not action(test, receive_money, (test, agent3, 0, receiving_item, 50)).
:- not failed(receive_money, (test, agent1, 0, receiving_item, 50), 1).