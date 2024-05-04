% test case 15 - test planning with receive with quality.
% expect satisfaction
time(0..10).
recv_item(0..2, apple, Quality) :- quality(Quality).
quality(0..10).
%
hold(notification((0, 0), apple, 100, 1), 0).
occur(receive((0, 0), apple, 100, 1), 0).
%
hold(notification((1, 1), apple, 400, 1), 0).
%
:- not hold(available_item(apple, 100, 1), 1..4). 
:- hold(available_item(apple, 100, 2), 1..4). 
:- hold(available_item(apple, 200, 1), 1..4). 
:- hold(available_item(apple, 300, 1), 1..4). 
:- hold(available_item(apple, 400, 1), 1..4). 
:- hold(available_item(apple, 400, 2), 1..4). 
%
occur(receive((1, 1), apple, 400, 1), 4).
:- hold(available_item(apple, 100, 1), 5). 
:- hold(available_item(apple, 400, 1), 5..10). 
:- not hold(available_item(apple, 500, 1), 5..10). 
%
:- not hold(notification((1, 1), apple, 400, 1), 0..4).
:- hold(notification((1, 1), apple, 400, 1), 5..10).