% test 1 - test produce with no quality- normal case, edge case
% expect satisfaction 
% test state
produce_item(test, wood).  
number(100).
number(201).
number(1).
time(0..10).

% test condition
% test initial state
:- not hold(available_item, (test, (wood, 0)), 0). 

% test dynamic law 
occur(produce, (test, wood, 100), 1).
% edge case 1
:- not hold(available_item, (test, (wood, 0)), 1). 
:- not hold(available_item, (test, (wood, 100)), 2). 
%
:- not hold(total_produced, (test, (wood, 0)), 1). 
:- not hold(total_produced, (test, (wood, 100)), 2). 
%
:- hold(total_produced, (test, (wood, 0)), 2). 
:- hold(total_produced, (test, (wood, 200)), 2). 

% middle case
occur(produce, (test, wood, 201), 5).
:- not hold(available_item, (test, (wood, 100)), 5). 
:- not hold(available_item, (test, (wood, 301)), 6). 
%
:- not hold(total_produced, (test, (wood, 100)), 5). 
:- not hold(total_produced, (test, (wood, 301)), 6). 
%
:-  hold(total_produced, (test, (wood, 0)), 6). 
:-  hold(total_produced, (test, (wood, 100)), 6). 
:-  hold(total_produced, (test, (wood, 200)), 6). 

% middle case
occur(produce, (test, wood, 1), 8).
%
:- not hold(available_item, (test, (wood, 301)), 8). 
:- not hold(available_item, (test, (wood, 302)), 9). 
%
:- not hold(total_produced, (test, (wood, 301)), 8). 
:- not hold(total_produced, (test, (wood, 302)), 9). 
%
% :- hold(produced(wood, 0), 8). 
% :- hold(produced(wood, 100), 8). 
% :- hold(produced(wood, 300), 8). 
% :- hold(produced(wood, 200), 9). 
:- hold(total_produced, (test, (wood, 0)), 8). 
:- hold(total_produced, (test, (wood, 100)), 8). 
:- hold(total_produced, (test, (wood, 300)), 8). 
:- hold(total_produced, (test, (wood, 200)), 9). 

% edge case 2
occur(produce, (test, wood, 1), 10).
:- not hold(available_item, (test, (wood, 302)), 10). 
%
% time ends at 10
:- hold(available_item, (test, (wood, _)), 11). 
%
:- hold(total_produced, (test, (wood, _)), 11). 

% test inertial rules
:- not hold(total_produced, (test, (wood, 301)), 6..8). 
:- not hold(total_produced, (test, (wood, 302)), 9..10). 
:- not hold(total_produced, (test, (wood, 100)), 2..5). 

:- hold(total_produced, (test, (wood, _)), 11). 
:- hold(total_produced, (test, (wood, 0)), 7..10). 
:- hold(total_produced, (test, (wood, 100)), 7..10). 
:- hold(total_produced, (test, (wood, 201)), 7..10). 