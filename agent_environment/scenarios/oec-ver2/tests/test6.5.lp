% test 6 - test receiving item with quality - error case - cannot receive items with wrong notification, wrong quantity
% expect unsatisfaction
% test state
time(0..10).
hold(available_item(receiving_item, 0, 1..10), 0).
pay_item(agent1, the_item).
recv_item(agent1, receiving_item, 1..10).
recv_item(agent2, receiving_item, 1..10).

% test condition
% test dynamic law 
% receive money 1
hold(notification((agent1, 1), receiving_item, 51, 1), 1). 
occur(receive((agent1, 1), receiving_item, 50, 1), 1).