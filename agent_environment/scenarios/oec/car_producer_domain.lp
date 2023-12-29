% domain for car producer
% other stuffs
quality(1..3).
time(1..10).
number(1..3).

% fluents
fluent(vehicle_part(X)) :- number(X).
fluent(radio_receiver(X)) :- number(X).
fluent(combustion_engine(X)) :- number(X).

% action
action(pay(X, Time)) :- number(X), time(Time).
action(receive(Fluent, Time)) :- fluent(Fluent), time(Time).