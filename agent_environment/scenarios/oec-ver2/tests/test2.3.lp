% test 2 - test deliver with quality - edge case of deliver all 
% expect satisfaction
% test state
deliver_item(agent1, wood, 0..10).
deliver_item(agent2, steel, 0..10).
time(0..10).
hold(available_item(wood, 201, 0..10), 0).
hold(available_item(steel, 201, 0..10), 0).
hold(delivered(agent1, wood, 0, 0..10), 0).
hold(delivered(agent2, steel, 0, 0..10), 0).

% test dynamic law 
occur(deliver(agent1, wood, 201, 1), 2).
occur(deliver(agent2, steel, 201, 1), 7).

%
:- not hold(available_item(wood, 0, 1), 3..10).
:- not hold(available_item(steel, 0, 1), 8..10).
:- not hold(delivered(agent1, wood, 201, 1), 3..10).
:- not hold(delivered(agent2, steel, 201, 1), 8..10).

