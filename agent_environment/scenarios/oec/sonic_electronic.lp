% domain for sonic electronics 
% other stuffs
quality(1..3).
time(1..10).
number(1..3).

% fluents 
fluent(radio_receiver(X, Quality)) :- number(X), quality(Quality).

% actions
action(produce(radio_receiver(X), Time)) :- number(X), time(Time).
action(deliver(radio_receiver(X), Time)) :- number(X), time(Time). 





