% test 6 - test receiving items 
% test state
time(0..10).
hold(available_item(receiving_item, 0), 0).
pay_item(the_item).
recv_item(receiving_item).
recv_agent(0..4).

% test condition
% test dynamic law 
% receive money 1
hold(notification((0, 0), receiving_item, 50), 1). 
occur(receive((0, 0), receiving_item, 50), 1).
:- not hold(available_item(receiving_item, 0), 1).
:- not hold(available_item(receiving_item, 50), 2).
% receive money 2 (with a gap from 1) 
hold(notification((1, 0), receiving_item, 101), 3). 
occur(receive((1, 0), receiving_item, 101), 3).
:- not hold(available_item(receiving_item, 50), 3).
:- not hold(available_item(receiving_item, 151), 4).
% receive money 3 (continuation of 2)
hold(notification((2, 0), receiving_item, 102), 5). 
occur(receive((2, 0), receiving_item, 102), 5).
:- not hold(available_item(receiving_item, 151), 5).
:- not hold(available_item(receiving_item, 253), 6).

% no same signature
% test intertial rules
:- hold(notification((0, 0), receiving_item, 50), 2..10). 
:- hold(notification((0, 0), receiving_item, 101), 4..10). 
:- hold(available_item(receiving_item, 151), 6..10).
:- not hold(available_item(receiving_item, 253), 6..10).

% % this notification should hold
hold(notification((0, 1), receiving_item, 50), 1). 
:- not hold(notification((0, 1), receiving_item, 50), 2..10). 
