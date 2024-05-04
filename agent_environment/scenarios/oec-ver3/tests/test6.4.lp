% test 6 - test receiving items with no quality - error case - cannot receive items with wrong notification, wrong quantity
% expect unsatisfaction
% test state
time(0..10).
hold(available_item(receiving_item, 0), 0).
pay_item(agent1, the_item).
recv_item(agent1, receiving_item).
recv_item(agent2, receiving_item).

% test condition
% test dynamic law 
% receive money 1
hold(notification((agent1, 1), receiving_item, 51), 1). 
occur(receive((agent1, 1), receiving_item, 50), 1).