% test 5 - test receiving money - normal case and edge case 
% expect satisfaction
% test state
time(0..10).
hold(available_funds(0), 0).
hold(payment(agent1, received, receiving_item, 0), 0).
hold(payment(agent2, received, receiving_apple, 0), 0).
receiving_reason(agent1, receiving_item).
receiving_reason(agent2, receiving_apple).

% test condition
% test dynamic law 
% receive money 1
hold(notification((agent1, 0), payment, receiving_item, 50), 1). 
occur(receive_money((agent1, 0), receiving_item, 50), 1).
:- not hold(available_funds(0), 1).
:- not hold(available_funds(50), 2).
:- not hold(payment(agent1, received, receiving_item, 0), 0..1).
:- not hold(payment(agent1, received, receiving_item, 50), 2..3).

% receive money 2 (with a gap from 1) 
hold(notification((agent1, 1), payment, receiving_item, 101), 3). 
occur(receive_money((agent1, 1), receiving_item, 101), 3).
:- not hold(available_funds(50), 3).
:- not hold(available_funds(151), 4..5).
:- not hold(payment(agent1, received, receiving_item, 151), 4..5).

% receive money 3 (continuation of 2)
hold(notification((agent1, 2), payment, receiving_item, 102), 5). 
occur(receive_money((agent1, 2), receiving_item, 102), 5).
:- not hold(available_funds(151), 5).
:- not hold(available_funds(253), 6..7).
:- not hold(payment(agent1, received, receiving_item, 253), 6..10).
:- hold(payment(agent1, received, receiving_item, 151), 6..10).
:- hold(payment(agent1, received, receiving_item, 50), 6..10).
:- hold(payment(agent1, received, receiving_item, 0), 6..10).

% receive money 4 for apple (continuation of 2)
hold(notification((agent2, 3), payment, receiving_apple, 102), 0). 
occur(receive_money((agent2, 3), receiving_apple, 102), 7).
:- not hold(payment(agent2, received, receiving_apple, 102), 8..10).
:- not hold(payment(agent2, received, receiving_apple, 0), 0..7).
:- hold(payment(agent2, received, receiving_apple, 102), 0..7).
:- hold(payment(agent2, received, receiving_item, 151), 7..10).
:- hold(payment(agent2, received, receiving_item, 50), 7..10).
:- hold(payment(agent2, received, receiving_item, 0), 7..10).
:- not hold(available_funds(355), 8..10).
:- hold(available_funds(253), 8..10).

% test intertial rules of notifications. 
% inertial rules testing for payment and available_funds, has been tested above.
% unused notifications will be  passed over
:- not hold(notification((agent2, 3), payment, receiving_apple, 102), 1..7). 
% used notifications will not be passed over
:- hold(notification((agent2, 3), payment, receiving_apple, 102), 8..10). 
:- hold(notification((agent1, 0), payment, receiving_item, 50), 2..10). 
:- hold(notification((agent1, 1), payment, receiving_item, 101), 4..10). 