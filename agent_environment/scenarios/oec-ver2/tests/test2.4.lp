% test 2 - test deliver with no quality - error case of not having enough to deliver
% expect unsatisfaction
% test state
deliver_item(agent1, wood).
deliver_item(agent2, steel).
time(0..10).
hold(available_item(wood, 201), 0).
hold(available_item(steel, 203), 0).
hold(delivered(agent1, wood, 0), 0).
hold(delivered(agent2, steel, 0), 0).

% test dynamic law 
occur(deliver(agent1, wood, 202), 2).