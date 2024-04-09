% test 1 - test produce with item with quality- normal case, edge case
% expect satisfaction 
% test state
produce_item(test, wood, 0..10).
time(0..10).
number(201).
number(100).
number(1).

% test condition
% test initial state
% :- not hold(available_quality_item, (test, (wood, 3, 0)), 0). 
% #show require/3.

% test dynamic law 
occur(produce_quality, (test, wood, 1, 100), 1).
#show hold/3.
% edge case 1
:- not hold(available_quality_item, (test, (wood, 1, 0)), 1). 
:- not hold(available_quality_item, (test, (wood, 1, 100)), 2). 
% %
:- not hold(total_produced_quality, (test, (wood, 1, 0)), 1). 
:- not hold(total_produced_quality, (test, (wood, 1, 100)), 2). 
% %
:- hold(total_produced_quality, (test, (wood, 1, 0)), 2). 
:- hold(total_produced_quality, (test, (wood, 1, 200)), 2). 

% % middle case
occur(produce_quality, (test, wood, 1, 201), 5).
%
:- not hold(available_quality_item, (test, (wood, 1, 100)), 5). 
:- not hold(available_quality_item, (test, (wood, 1, 301)), 6). 

:- not hold(total_produced_quality, (test, (wood, 1, 100)), 5). 
:- not hold(total_produced_quality, (test, (wood, 1, 301)), 6). 
%
:- hold(total_produced_quality, (test, (wood, 1, 0)), 6). 
:- hold(total_produced_quality, (test, (wood, 1, 100)), 6). 
:- hold(total_produced_quality, (test, (wood, 1, 200)), 6). 

% % middle case
occur(produce_quality, (test, wood, 1, 1), 8).
% %
:- not hold(available_quality_item, (test, (wood, 1, 301)), 8). 
:- not hold(available_quality_item, (test, (wood, 1, 302)), 9). 
% %
:- not hold(total_produced_quality, (test, (wood, 1, 301)), 8). 
:- not hold(total_produced_quality, (test, (wood, 1, 302)), 9). 
% %
:- hold(total_produced_quality, (test, (wood, 1, 0)), 8). 
:- hold(total_produced_quality, (test, (wood, 1, 100)), 8). 
:- hold(total_produced_quality, (test, (wood, 1, 300)), 9). 
:- hold(total_produced_quality, (test, (wood, 1, 200)), 9). 

% % edge case 2
occur(produce_quality, (test, wood, 1, 1), 10).
% %
:- not hold(available_quality_item, (test, (wood, 1, 302)), 10). 
% % time ends at 10
:- hold(available_quality_item, (test, (wood, 1, 302)), 11). 
:- hold(available_quality_item, (test, (wood, 1, 302)), 11). 
:- hold(available_quality_item, (test, (wood, 1, 301)), 11). 
% %
:- hold(total_produced_quality, (test, (wood, 1, 301)), 11). 
:- hold(total_produced_quality, (test, (wood, 1, 302)), 11). 
:- hold(total_produced_quality, (test, (wood, 1, 303)), 11). 

% % test inertial rules
:- hold(total_produced_quality, (test, (wood, 1, 301)), 9..10). 
:- hold(total_produced_quality, (test, (wood, 1, 201)), 2..5). 
:- hold(total_produced_quality, (test, (wood, 1, _)), 11). 
:- hold(total_produced_quality, (test, (wood, 1, 0)), 7..10). 