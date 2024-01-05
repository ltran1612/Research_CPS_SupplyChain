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
action(produce(iron_spring(X), Time)) :- number(X), time(Time).
action(deliver(iron_spring(X), Time)) :- number(X), time(Time). 


% dynamic laws
hold(iron_spring(A+B), Time+1) :- hold(iron_spring(A), Time), occur(produce(iron_spring(B)), Time). 
hold(iron_spring(A-B), Time+1) :- hold(iron_spring(A), Time), occur(deliver(iron_spring(B)), Time). 

% inertial laws
not_changing(iron_spring, Time) :- not occur(produce(iron_spring(_)), Time), not occur(deliver(iron_spring(_)), Time), time(Time).
hold(iron_spring(A), Time+1) :- hold(iron_spring(A), Time), not_changing(iron_spring, Time). 

% static casual laws

% initial states
hold(iron_spring(0), 1).

% actions to do
occur(produce(iron_spring(1000)), 1).
occur(deliver(iron_spring(1000)), 3).

#show hold/2.
% #show not_changing/2.