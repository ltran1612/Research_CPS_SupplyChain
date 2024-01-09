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

% dynamic laws
hold(radio_receiver(A+B), Time+1) :- hold(radio_receiver(A), Time), occur(produce(radio_receiver(B)), Time). 
hold(radio_receiver(A-B), Time+1) :- hold(radio_receiver(A), Time), occur(deliver(radio_receiver(B)), Time). 

% inertial laws
not_changing(radio_receiver, Time) :- not occur(produce(radio_receiver(_)), Time), not occur(deliver(radio_receiver(_)), Time), time(Time).
hold(radio_receiver(A), Time+1) :- hold(radio_receiver(A), Time), not_changing(radio_receiver, Time). 

% static casual laws

% % initial states
% hold(radio_receiver(0), 1).

% % actions to do
% occur(produce(radio_receiver(1000)), 1).
% occur(deliver(radio_receiver(1000)), 3).

% #show hold/2.
% #show not_changing/2.