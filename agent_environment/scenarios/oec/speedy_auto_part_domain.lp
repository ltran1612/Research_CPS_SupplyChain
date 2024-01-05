% speedy auto parts
% other stuffs
quality(1..3).
time(1..10).
number(1..3).

% fluents   
fluent(iron_spring(X, Quality)) :- number(X), quality(Quality). 
fluent(inter_tool_part(X)) :- number(X).
fluent(leather_article(X)) :- number(X).
fluent(vehicle_part(X)) :- number(X).

% action
action(produce(vehicle_part(X), Time)) :- number(X), time(Time).
action(deliver(vehicle_part(X), Time)) :- number(X), time(Time).
action(pay(X, Time)) :- number(X), time(Time).
