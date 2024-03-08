% test 1 - test produce - normal case, edge case
% expect satisfaction 
% test state
produce_item(wood).
time(0..10).

% test condition
% test initial state
:- not hold(available_item(wood, 0), 0). 

% test dynamic law 
occur(produce(wood, 100), 1).
% edge case 1
:- not hold(available_item(wood, 0), 1). 
:- not hold(available_item(wood, 100), 2). 
%
:- not hold(produced(wood, 0), 1). 
:- not hold(produced(wood, 100), 2). 
%
:- hold(produced(wood, 0), 2). 
:- hold(produced(wood, 200), 2). 

% middle case
occur(produce(wood, 201), 5).
%
:- not hold(available_item(wood, 100), 5). 
:- not hold(available_item(wood, 301), 6). 
%
:- not hold(produced(wood, 100), 5). 
:- not hold(produced(wood, 301), 6). 
%
:- hold(produced(wood, 0), 6). 
:- hold(produced(wood, 100), 6). 
:- hold(produced(wood, 200), 6). 

% % middle case
occur(produce(wood, 1), 8).
%
:- not hold(available_item(wood, 301), 8). 
:- not hold(available_item(wood, 302), 9). 
%
:- not hold(produced(wood, 301), 8). 
:- not hold(produced(wood, 302), 9). 
%
:- hold(produced(wood, 0), 8). 
:- hold(produced(wood, 100), 8). 
:- hold(produced(wood, 300), 8). 
:- hold(produced(wood, 200), 9). 

% edge case 2
occur(produce(wood, 1), 10).
%
:- not hold(available_item(wood, 302), 10). 
% time ends at 10
:- hold(available_item(wood, 303), 11). 
:- hold(available_item(wood, 302), 11). 
:- hold(available_item(wood, 301), 11). 
%
:- hold(produced(wood, 301), 11). 
:- hold(produced(wood, 302), 11). 
:- hold(produced(wood, 303), 11). 

% test inertial rules
:- not hold(produced(wood, 301), 6..8). 
:- not hold(produced(wood, 302), 9..10). 
:- not hold(produced(wood, 100), 2..5). 
:- hold(produced(wood, _), 11). 
:- hold(produced(wood, 0), 7..10). 
:- hold(produced(wood, 100), 7..10). 
:- hold(produced(wood, 201), 7..10). 