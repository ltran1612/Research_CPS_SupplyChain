% test 6 - test notifications with both quality and non-quality items- error case - cannot 2 different notifications with the same key, one for item with quality one for item with no quality
% expect unsatisfaction
% test state
time(0..10).
recv_item(agent1, receiving_item, 1..10).
recv_item(agent1, receiving_item1).

% test condition
% test dynamic law 
% receive money 1
hold(notification((agent1, 1), receiving_item1, 50), 1). 
hold(notification((agent1, 1), receiving_item, 50, 1), 1). 