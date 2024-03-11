% test 10 - test receiving items  with quality
% expect satisfaction
% test state
time(0..10).
hold(available_item(receiving_item, 0, 1), 0).
pay_item(0..4, the_item, Quality) :- quality(Quality).
recv_item(0..4, receiving_item, Quality) :- quality(Quality).
quality(1..10).

% test condition
% test dynamic law 
% receive money 1
hold(notification((0, 0), receiving_item, 50, 1), 1). 
occur(receive((0, 0), receiving_item, 50, 1), 1).
:- not hold(available_item(receiving_item, 0, 1), 1).
:- not hold(available_item(receiving_item, 50, 1), 2).
% receive money 2 (with a gap from 1) 
hold(notification((1, 0), receiving_item, 101, 1), 3). 
occur(receive((1, 0), receiving_item, 101, 1), 3).
:- not hold(available_item(receiving_item, 50, 1), 3).
:- not hold(available_item(receiving_item, 151, 1), 4).
% receive money 3 (continuation of 2)
hold(notification((2, 0), receiving_item, 102, 1), 5). 
occur(receive((2, 0), receiving_item, 102, 1), 5).
:- not hold(available_item(receiving_item, 151, 1), 5).
:- not hold(available_item(receiving_item, 253, 1), 6).

% % no same signature
% % test intertial rules
:- hold(notification((0, 0), receiving_item, 50, 1), 2..10). 
:- hold(notification((0, 0), receiving_item, 101, 1), 4..10). 
:- hold(available_item(receiving_item, 151, 1), 6..10).
:- not hold(available_item(receiving_item, 253, 1), 6..10).
