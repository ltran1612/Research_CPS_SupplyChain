% test 6 - test receiving item with quality - normal case and edge case
% expect satisfaction
% test state
time(0..10).
hold(available_item(receiving_item, 0, 1..10), 0).
hold(received(agent1, receiving_item, 0, 1..10), 0).
hold(received(agent2, receiving_item, 0, 1..10), 0).
pay_item(agent1, the_item).
recv_item(agent1, receiving_item, 1..10).
recv_item(agent2, receiving_item, 1..10).

% test condition
% test dynamic law 
% receive money 1
hold(notification((agent1, 1), receiving_item, 50, 1), 1). 
occur(receive((agent1, 1), receiving_item, 50, 1), 1).
:- not hold(available_item(receiving_item, 0, 1), 1).
:- not hold(available_item(receiving_item, 50, 1), 2).
:- not hold(received(agent1, receiving_item, 0, 1), 1).
:- not hold(received(agent1, receiving_item, 50, 1), 2).
% receive money 2 (with a gap from 1) 
hold(notification((agent2, 2), receiving_item, 101, 1), 3). 
occur(receive((agent2, 2), receiving_item, 101, 1), 3).
:- not hold(available_item(receiving_item, 50, 1), 3).
:- not hold(available_item(receiving_item, 151, 1), 4).
:- not hold(received(agent2, receiving_item, 0, 1), 3).
:- not hold(received(agent2, receiving_item, 101, 1), 4).
% receive money 3 (continuation of 2)
hold(notification((agent1, 3), receiving_item, 102, 1), 5). 
occur(receive((agent1, 3), receiving_item, 102, 1), 5).
:- not hold(available_item(receiving_item, 151, 1), 5).
:- not hold(available_item(receiving_item, 253, 1), 6).
:- not hold(received(agent1, receiving_item, 50, 1), 5).
:- not hold(received(agent1, receiving_item, 152, 1), 6).

% edge case
:- hold(available_item(receiving_item, _, 1), 11).

% no same signature
% test intertial rules
:- hold(notification((agent1, 1), receiving_item, 50, 1), 2..10). 
:- hold(notification((agent2, 2), receiving_item, 101, 1), 4..10). 
:- hold(available_item(receiving_item, 151), 6..10).
:- not hold(available_item(receiving_item, 253, 1), 6..10).
:- not hold(received(agent1, receiving_item, 152, 1), 6..10).
:- not hold(received(agent2, receiving_item, 101, 1), 6..10).

% this notification should hold
hold(notification((agent2, 1), receiving_item, 50, 1), 1). 
:- not hold(notification((agent2, 1), receiving_item, 50, 1), 2..10). 
