% test case 14 - test planning with receive.
time(0..10).
recv_item(0..2, apple).
%
hold(notification((0, 0), apple, 100), 0).
occur(receive((0, 0), apple, 100), 0).
%
hold(notification((1, 1), apple, 400), 0).
%
:- not hold(available_item(apple, 100), 1..4). 
:- hold(available_item(apple, 200), 1..4). 
:- hold(available_item(apple, 300), 1..4). 
:- hold(available_item(apple, 400), 1..4). 
%
occur(receive((1, 1), apple, 400), 4).
:- hold(available_item(apple, 100), 5). 
:- hold(available_item(apple, 400), 5..10). 
:- not hold(available_item(apple, 500), 5..10). 
%
:- not hold(notification((1, 1), apple, 400), 0..4).
:- hold(notification((1, 1), apple, 400), 5..10).