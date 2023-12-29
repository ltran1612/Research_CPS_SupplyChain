% domain for metal craft solutions 
% other stuffs
quality(1..3).
time(1..10).
number(1..3).

% fluents 
fluent(steel_wire(X)) :- number(X). 
fluent(titanium_oxide(X)) :- number(X). 
fluent(iron_spring(X)) :- number(X). 
fluent(polyamides(X)) :- number(X). 

% actions
action(produce(X), Time) :- fluent(X), time(Time).
action(deliver(X), Time) :- fluent(X), time(Time). 





