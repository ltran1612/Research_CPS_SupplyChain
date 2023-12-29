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
action(produce(X, Time)) :- fluent(X), time(Time).
action(deliver(X, Time)) :- fluent(X), time(Time).
