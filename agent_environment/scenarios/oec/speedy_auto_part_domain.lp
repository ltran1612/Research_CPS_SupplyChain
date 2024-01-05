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

% constraints
% :- occur(produce(vehicle_part(A), Time)), 
%     hold(inter_tool_part(Y), Time), 
%     hold(leather_article(Z), Time), 
%     hold(iron_spring(X), Time).

% dynamic laws
hold(vehicle_part(A+B), Time+1) :- hold(vehicle_part(A), Time), occur(produce(vehicle_part(B)), Time). 
hold(vehicle_part(A-B), Time+1) :- hold(vehicle_part(A), Time), occur(deliver(vehicle_part(B)), Time). 

% inertial laws
not_changing(vehicle_part, Time) :- not occur(produce(vehicle_part(_)), Time), not occur(deliver(vehicle_part(_)), Time), time(Time).
hold(vehicle_part(A), Time+1) :- hold(vehicle_part(A), Time), not_changing(vehicle_part, Time). 

% static casual laws

% initial states
hold(vehicle_part(0), 1).

% actions to do
occur(produce(vehicle_part(1000)), 1).
occur(deliver(vehicle_part(1000)), 3).

#show hold/2.
% #show not_changing/2.
