% test 2 - test deliver with no quality - error case of not having enough to deliver
% expect satisfaction 
% test state
deliver_item(test, agent1, wood).
deliver_item(test, agent2, steel).
time(0..10).
% #show hold/3.
% #show operation/4.
number(202).
hold(available_item, (test, (wood, 201)), 0).
hold(available_item, (test, (steel, 203)), 0).
hold(total_delivered, (test, (agent1, wood, 0)), 0).
hold(total_delivered, (test, (agent2, steel, 0)), 0).

% test dynamic law 
occur(deliver, (test, (agent1, wood, 202)), 2).
:- not hold(available_item, (test, (wood, 201)), 3..10).
:- not hold(available_item, (test, (steel, 203)), 3..10).
:- not failed(deliver, (test, (agent1, wood, 202)), 2).