% test 6 - test notifications with quality - error case - cannot 2 different notifications with the same key, different item and different quantity, and different quality 
% expect unsatisfaction
% test state
time(0..10).
hold(available_item(receiving_item, 0, 1..10), 0).
pay_item(agent1, the_item).
recv_item(agent1, receiving_item, 1..10).
recv_item(agent1, receiving_item1, 1..10).
recv_item(agent2, receiving_item, 1..10).

% test condition
% test dynamic law 
% receive money 1
hold(notification((agent1, 1), receiving_item1, 51, 2), 1). 
hold(notification((agent1, 1), receiving_item, 50, 1), 1). 