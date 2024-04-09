% test 2 - test deliver with quality - edge case of deliver all 
% expect satisfaction
% test state
deliver_item(test, agent1, wood, 0..10).
deliver_item(test, agent2, steel, 0..10).
time(0..10).
hold(available_quality_item, (test, (wood, 0..10, 201)), 0).
hold(available_quality_item, (test, (steel, 0..10, 201)), 0).
hold(total_delivered_quality, (test, (agent1, wood, 0..10, 0)), 0).
hold(total_delivered_quality, (test, (agent2, steel, 0..10, 0)), 0).
number(201).

% test dynamic law 
occur(deliver_quality, (test, agent1, wood, 1, 201), 2).
occur(deliver_quality, (test, agent2, steel, 1, 201), 7).

%
:- not hold(available_quality_item, (test, (wood, 1, 0)), 3..10).
% :- not hold(available_quality_item, (test, (steel, 1, 0)), 8..10).
% :- not hold(total_delivered_quality, (test, (agent1, wood, 201, 1)), 3..10).
% :- not hold(total_delivered_quality, (test, (agent2, steel, 201, 1)), 8..10).

