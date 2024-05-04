% test 6 - test notifications with no quality - error case - cannot 2 different notifications with the same key, different item. 
% expect unsatisfaction
% test state
time(0..10).
hold(available_item(receiving_item, 0), 0).
pay_item(agent1, the_item).
recv_item(agent1, receiving_item).
recv_item(agent1, receiving_item1).
recv_item(agent2, receiving_item).

% test condition
% test dynamic law 
% receive money 1
hold(notification((agent1, 1), receiving_item, 50), 1). 
hold(notification((agent1, 1), receiving_item1, 50), 1). 