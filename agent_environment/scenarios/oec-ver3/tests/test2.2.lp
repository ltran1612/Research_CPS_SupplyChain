% test 2 - test deliver with no quality - edge case of deliver all 
% expect satisfaction
% test state
deliver_item(test, agent1, wood).
deliver_item(test, agent2, steel).
time(0..10).
hold(available_item, (test, (wood, 201)), 0).
hold(available_item, (test, (steel, 201)), 0).
hold(total_delivered, (test, (agent2, steel, 0)), 0).
hold(total_delivered, (test, (agent1, wood, 0)), 0).
hold(total_delivered, (test, (agent2, steel, 0)), 0).
number(201).

% test dynamic law 
occur(deliver, (test, (agent1, wood, 201)), 2).
occur(deliver, (test, (agent2, steel, 201)), 7).

%
:- not hold(available_item, (test, (wood, 0)), 3..10).
:- not hold(available_item, (test, (steel, 0)), 8..10).
:- not hold(total_delivered, (test, (agent1, wood, 201)), 3..10).
:- not hold(total_delivered, (test, (agent2, steel, 201)), 8..10).

