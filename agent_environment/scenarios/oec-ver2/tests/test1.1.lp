% test 1 - test produce with item with quality- normal case, edge case
% expect satisfaction 
% test state
produce_item(wood, 0..10).
time(0..10).

% test condition
% test initial state
:- not hold(available_item(wood, 0, 3), 0). 

% test dynamic law 
occur(produce(wood, 100, 1), 1).
% edge case 1
:- not hold(available_item(wood, 0, 1), 1). 
:- not hold(available_item(wood, 100, 1), 2). 
%
:- not hold(produced(wood, 0, 1), 1). 
:- not hold(produced(wood, 100, 1), 2). 
%
:- hold(produced(wood, 0, 1), 2). 
:- hold(produced(wood, 200, 1), 2). 

% middle case
occur(produce(wood, 201, 1), 5).
%
:- not hold(available_item(wood, 100, 1), 5). 
:- not hold(available_item(wood, 301, 1), 6). 
%
:- not hold(produced(wood, 100, 1), 5). 
:- not hold(produced(wood, 301, 1), 6). 
%
:- hold(produced(wood, 0, 1), 6). 
:- hold(produced(wood, 100, 1), 6). 
:- hold(produced(wood, 200, 1), 6). 

% middle case
occur(produce(wood, 1, 1), 8).
%
:- not hold(available_item(wood, 301, 1), 8). 
:- not hold(available_item(wood, 302, 1), 9). 
%
:- not hold(produced(wood, 301, 1), 8). 
:- not hold(produced(wood, 302, 1), 9). 
%
:- hold(produced(wood, 0, 1), 8). 
:- hold(produced(wood, 100, 1), 8). 
:- hold(produced(wood, 300, 1), 8). 
:- hold(produced(wood, 200, 1), 9). 

% edge case 2
occur(produce(wood, 1, 1), 10).
%
:- not hold(available_item(wood, 302, 1), 10). 
% time ends at 10
:- hold(available_item(wood, 303, 1), 11). 
:- hold(available_item(wood, 302, 1), 11). 
:- hold(available_item(wood, 301, 1), 11). 
%
:- hold(produced(wood, 301, 1), 11). 
:- hold(produced(wood, 302, 1), 11). 
:- hold(produced(wood, 303, 1), 11). 

% test inertial rules
:- not hold(produced(wood, 301, 1), 6..8). 
:- not hold(produced(wood, 302, 1), 9..10). 
:- not hold(produced(wood, 100, 1), 2..5). 
:- hold(produced(wood, _), 11). 
:- hold(produced(wood, 0, 1), 7..10). 
:- hold(produced(wood, 100, 1), 7..10). 
:- hold(produced(wood, 201, 1), 7..10). 