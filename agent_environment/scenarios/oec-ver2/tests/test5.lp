% test 5 - test receiving money 
% test state
time(0..10).
hold(available_funds(0), 0).
pay_item(the_item).
recv_item(receiving_item).
recv_agent(0..4).

% test condition
% test dynamic law 
% receive money 1
hold(notification((0, 0), payment, receiving_item, 50), 1). 
occur(receive_money((0, 0), receiving_item, 50), 1).
:- not hold(available_funds(0), 1).
:- not hold(available_funds(50), 2).
% receive money 2 (with a gap from 1) 
hold(notification((1, 0), payment, receiving_item, 101), 3). 
occur(receive_money((1, 0), receiving_item, 101), 3).
:- not hold(available_funds(50), 3).
:- not hold(available_funds(151), 4).
% receive money 3 (continuation of 2)
hold(notification((2, 0), payment, receiving_item, 102), 5). 
occur(receive_money((2, 0), receiving_item, 102), 5).
:- not hold(available_funds(151), 5).
:- not hold(available_funds(253), 6).

% % no same signature

% % test intertial rules
:- hold(notification((0, 0), payment, receiving_item, 50), 2..10). 
:- hold(notification((0, 0), payment, receiving_item, 101), 4..10). 
:- not hold(available_funds(151), 4..5).

% 
hold(notification((2, 1), payment, receiving_item, 102), 0). 
:- not hold(notification((2, 1), payment, receiving_item, 102), 0..10). 