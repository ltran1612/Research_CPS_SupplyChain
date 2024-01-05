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
action(produce(steel_wire(X), Time)) :- number(X), time(Time).
action(deliver(steel_wire(X), Time)) :- number(X), time(Time). 

action(produce(titanium_oxide(X), Time)) :- number(X), time(Time).
action(deliver(titanium_oxide(X), Time)) :- number(X), time(Time). 

action(produce(iron_spring(X), Time)) :- number(X), time(Time).
action(deliver(iron_spring(X), Time)) :- number(X), time(Time). 

action(produce(polyamides(X), Time)) :- number(X), time(Time).
action(deliver(polyamides(X), Time)) :- number(X), time(Time). 