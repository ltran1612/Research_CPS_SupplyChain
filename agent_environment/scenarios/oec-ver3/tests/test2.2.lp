% test 2 - test deliver with no quality - edge case of deliver all 
% expect satisfaction
% test state
deliver_item(agent1, wood).
deliver_item(agent2, steel).
time(0..10).
hold(available_item(wood, 201), 0).
hold(available_item(steel, 201), 0).
hold(delivered(agent1, wood, 0), 0).
hold(delivered(agent2, steel, 0), 0).

% test dynamic law 
occur(deliver(agent1, wood, 201), 2).
occur(deliver(agent2, steel, 201), 7).

%
:- not hold(available_item(wood, 0), 3..10).
:- not hold(available_item(steel, 0), 8..10).
:- not hold(delivered(agent1, wood, 201), 3..10).
:- not hold(delivered(agent2, steel, 201), 8..10).

