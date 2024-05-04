% test 2 - test deliver with quality - error case of not having to deliver
% expect satisfaction 
% test state
deliver_item(test, agent1, wood, 0..10).
deliver_item(test, agent2, steel, 0..10).
time(0..10).
hold(available_quality_item, (test, (wood, 0..10, 201)), 0).
hold(available_quality_item, (test, (steel, 0..10, 204)), 0).
hold(total_delivered_quality, (test, (agent1, wood, 0..10, 0)), 0).
hold(total_delivered_quality, (test, (agent2, steel, 0..10), 0), 0).

% test dynamic law 
occur(deliver_quality, (test, (agent1, wood, 1, 203)), 2).
:- not hold(available_quality_item, (test, (wood, 0..10, 201)), 3..10).
:- not hold(available_quality_item, (test, (steel, 0..10, 204)), 3..10).
:- not failed(deliver_quality, (test, (agent1, wood, 1, 203)), 2).


