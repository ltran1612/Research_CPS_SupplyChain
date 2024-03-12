% test 6 - test receiving items with no quality - normal case
% expect satisfaction
% test state
time(0..10).
hold(available_item(receiving_item, 0), 0).
pay_item(agent1, the_item).
recv_item(agent1, receiving_item).
recv_item(agent2, receiving_item).

% test condition
% test dynamic law 
% receive money 1
hold(notification((agent1, 1), receiving_item, 50), 1). 
occur(receive((agent1, 1), receiving_item, 50), 1).
:- not hold(available_item(receiving_item, 0), 1).
:- not hold(available_item(receiving_item, 50), 2).
% receive money 2 (with a gap from 1) 
hold(notification((agent1, 2), receiving_item, 101), 3). 
occur(receive((agent1, 2), receiving_item, 101), 3).
:- not hold(available_item(receiving_item, 50), 3).
:- not hold(available_item(receiving_item, 151), 4).
% receive money 3 (continuation of 2)
hold(notification((agent1, 3), receiving_item, 102), 5). 
occur(receive((agent1, 3), receiving_item, 102), 5).
:- not hold(available_item(receiving_item, 151), 5).
:- not hold(available_item(receiving_item, 253), 6).

% no same signature
% test intertial rules
:- hold(notification((agent1, 1), receiving_item, 50), 2..10). 
:- hold(notification((agent1, 2), receiving_item, 101), 4..10). 
:- hold(available_item(receiving_item, 151), 6..10).
:- not hold(available_item(receiving_item, 253), 6..10).

% this notification should hold
hold(notification((agent2, 1), receiving_item, 50), 1). 
:- not hold(notification((agent2, 1), receiving_item, 50), 2..10). 
