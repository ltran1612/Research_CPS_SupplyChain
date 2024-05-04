% test 4 - test pay money  - test error case of not having enough money
% expect unsatisfaction.
% test state
time(0..10).
hold(available_funds(100), 0).
hold(payment(agent1, sent, the_item, 0), 0).
hold(payment(agent2, sent, the_service, 0), 0).
pay_item(agent1, the_item).
pay_item(agent2, the_service).

% test condition
% test dynamic law 
% edge case 1 
occur(pay(agent1, the_item, 101), 1).