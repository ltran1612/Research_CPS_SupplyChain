% domain for car producer
% other stuffs
quality(1..3).
% time(1..10).
% number(0..10000).

% fluents
fluent(vehicle_part(X)) :- number(X).
fluent(radio_receiver(X)) :- number(X).
fluent(combustion_engine(X)) :- number(X).
fluent(money(X)) :- number(X).
fluent(payment(vehicle_parts, X)) :- number(X).

% action
action(pay(vehicle_parts, X)) :- number(X). 
action(receive(Fluent, Time)) :- fluent(Fluent), time(Time).

% constraints
:- occur(pay(_, A), T), hold(money(B), T), not B >= A.

% dynamic law
hold(vehicle_part(A+B), T+1) :- hold(vehicle_part(A), T), occur(receive(vehicle_part(B), T)).

% money 
hold(money(A-B), T+1) :- hold(money(A), T), occur(pay(vehicle_parts, B), T).
hold(payment(vehicle_parts, A+B), T+1) :- hold(payment(vehicle_parts, A), T), 
    occur(pay(vehicle_parts, B), T).

% inertial rules
not_changing(vehicle_part, T) :- not occur(receive(vehicle_part(_), T)), time(T).
hold(vehicle_part(A), T+1) :- hold(vehicle_part(A), T), not_changing(vehicle_part, T).

% money
not_changing(money, T) :- not occur(pay(vehicle_parts, _), T), time(T).
hold(money(A), T+1) :- hold(money(A), T), not_changing(money, T).
hold(payment(vehicle_parts, A), T+1) :- hold(payment(vehicle_parts, A), T), not_changing(money, T).

