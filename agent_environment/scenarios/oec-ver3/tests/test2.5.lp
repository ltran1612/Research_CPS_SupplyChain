% test 2 - test deliver with quality - error case of not having to deliver
% expect unsatisfaction
% test state
deliver_item(agent1, wood, 0..10).
deliver_item(agent2, steel, 0..10).
time(0..10).
hold(available_item(wood, 201, 0..10), 0).
hold(available_item(steel, 204, 0..10), 0).
hold(delivered(agent1, wood, 0, 0..10), 0).
hold(delivered(agent2, steel, 0, 0..10), 0).

% test dynamic law 
occur(deliver(agent1, wood, 203, 1), 2).

