% domain for car producer
% other stuffs
quality(1..3).
time(1..10).
number(0..10000).

% fluents
fluent(vehicle_part(X)) :- number(X).
fluent(radio_receiver(X)) :- number(X).
fluent(combustion_engine(X)) :- number(X).
fluent(money(X)) :- number(X).

% action
action(pay(X)) :- number(X). 
action(receive(Fluent, Time)) :- fluent(Fluent), time(Time).

% constraints
:- occur(pay(A), T), hold(money(B), T), B >= A.
% dynamic law
hold(vehicle_part(A+B), T+1) :- hold(vehicle_part(A), T), occur(receive(vehicle_part(B), T)).

% money 
hold(money(A-B), T+1) :- hold(money(A), T), occur(pay(B), T).

