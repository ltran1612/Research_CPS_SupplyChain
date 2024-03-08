% test 5 - test receiving money 
% test state
time(0..10).
hold(available_funds(0), 0).
hold(payment(0..4, received, receiving_item, 0), 0).
hold(payment(0..4, received, receiving_apple, 0), 0).
receiving_reason(0..4, receiving_item).
receiving_reason(0..4, receiving_apple).

% test condition
% test dynamic law 
% receive money 1
hold(notification((0, 0), payment, receiving_item, 50), 1). 
occur(receive_money((0, 0), receiving_item, 50), 1).
:- not hold(available_funds(0), 1).
:- not hold(available_funds(50), 2).
:- not hold(payment(0, received, receiving_item, 0), 0..1).
:- not hold(payment(0, received, receiving_item, 50), 2..3).

% receive money 2 (with a gap from 1) 
hold(notification((0, 1), payment, receiving_item, 101), 3). 
occur(receive_money((0, 1), receiving_item, 101), 3).
:- not hold(available_funds(50), 3).
:- not hold(available_funds(151), 4).
:- not hold(payment(0, received, receiving_item, 151), 4..5).

% receive money 3 (continuation of 2)
hold(notification((0, 2), payment, receiving_item, 102), 5). 
occur(receive_money((0, 2), receiving_item, 102), 5).
:- not hold(available_funds(151), 5).
:- not hold(available_funds(253), 6).
:- not hold(payment(0, received, receiving_item, 253), 6..10).
:- hold(payment(0, received, receiving_item, 151), 6..10).
:- hold(payment(0, received, receiving_item, 50), 6..10).
:- hold(payment(0, received, receiving_item, 0), 6..10).

% receive money 4 for apple (continuation of 2)
hold(notification((0, 3), payment, receiving_apple, 102), 0). 
occur(receive_money((0, 3), receiving_apple, 102), 7).
:- not hold(payment(0, received, receiving_apple, 102), 8..10).
:- not hold(payment(0, received, receiving_apple, 0), 0..7).
:- hold(payment(0, received, receiving_apple, 102), 0..7).
:- hold(payment(0, received, receiving_item, 151), 7..10).
:- hold(payment(0, received, receiving_item, 50), 7..10).
:- hold(payment(0, received, receiving_item, 0), 7..10).
:- not hold(available_funds(355), 8..10).
:- hold(available_funds(253), 8..10).

% no same signature

% test intertial rules
:- not hold(notification((0, 3), payment, receiving_apple, 102), 2..7). 
:- hold(notification((0, 3), payment, receiving_apple, 102), 8..10). 
%
:- hold(notification((0, 0), payment, receiving_item, 50), 2..10). 
:- hold(notification((0, 0), payment, receiving_item, 101), 4..10). 
:- not hold(available_funds(151), 4..5).
% % 
hold(notification((2, 1), payment, receiving_item, 102), 0). 
:- not hold(notification((2, 1), payment, receiving_item, 102), 0..10). 