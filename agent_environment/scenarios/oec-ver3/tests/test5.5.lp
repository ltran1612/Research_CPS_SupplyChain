% test 5 - test receiving money - error case -  right notification, right item, but wrong quantity
% expect satisfaction
% test state
time(0..10).
hold(available_funds, (test, (0,)), 0).
hold(total_received_payment, (test, (agent1, receiving_item, 0)), 0).
hold(total_received_payment, (test, (agent2, receiving_apple, 0)), 0).
receiving_reason(test, agent1, receiving_item).
receiving_reason(test, agent3, receiving_item).
receiving_reason(test, agent2, receiving_apple).
receiving_reason(test, agent1, receiving_apple).
pay_item(agent1, test, receiving_item).
number(50).
number(10).

% test condition
% test dynamic law 
% receive money 1
hold(sent_payment, (agent1, (test, 0, receiving_item, 10)), 0). 
occur(receive_money, (test, agent1, 0, receiving_item, 50), 1).
:- not action(test, receive_money, (test, agent1, 0, receiving_item, 10)).
:- not failed(receive_money, (test, agent1, 0, receiving_item, 50), 1).