% test 6 - cannot declare an item to be both with quality and with no quality 
% expect unsatisfaction
% test state
recv_item(agent1, receiving_item, 1..10).
recv_item(agent1, receiving_item).
