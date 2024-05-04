% test 5 - test receiving money - error case - receive with no notification
% expect unsatisfaction 
% test state
time(0..10).
hold(available_funds(0), 0).
hold(payment(agent1, received, receiving_item, 0), 0).
hold(payment(agent2, received, receiving_apple, 0), 0).
receiving_reason(agent1, receiving_item).
receiving_reason(agent2, receiving_apple).

% test condition
% test dynamic law 
% receive money 1
occur(receive_money((agent1, 0), receiving_item, 50), 1).