% domain for Precision Engine
% other stuffs
quality(1..3).
time(1..10).
number(1..3).

% fluents 
fluent(combustion_engine(X, Quality)) :- number(X), quality(Quality).
fluent(delivered(combustion_engine(X, Quality), T)) :- number(X), quality(Quality), time(T).
fluent(payment(X, T)) :- number(X), time(T).
fluent(money(X)) :- number(X). 

% actions
action(produce(combustion_engine(X, Quality))) :- number(X), quality(Quality). 
action(deliver(combustion_engine(X, Quality))) :- number(X), quality(Quality). 

action(pay(X)) :- number(X), quality(Quality). 

% dynamic laws
hold(combustion_engine(A+B, Quality), Time+1) :- hold(combustion_engine(A, Quality), Time), occur(produce(combustion_engine(B, Quality)), Time). 
hold(combustion_engine(A-B, Quality), Time+1) :- hold(combustion_engine(A, Quality), Time), occur(deliver(combustion_engine(B, Quality)), Time). 

% delivered
hold(delivered(combustion_engine(B, Quality), Time), Time+1) :- occur(deliver(combustion_engine(B, Quality)), Time). 

% pay
hold(payment(B, Time), Time+1) :- occur(pay(B), Time).
hold(money(A+B), Time+1) :- hold(money(A), Time), occur(pay(B), Time).

% inertial laws
not_changing(combustion_engine(Quality), Time) :- 
    not occur(produce(combustion_engine(_, Quality)), Time), 
    not occur(deliver(combustion_engine(_, Quality)), Time), 
    time(Time), quality(Quality).
hold(combustion_engine(A, Quality), Time+1) :- hold(combustion_engine(A, Quality), Time), not_changing(combustion_engine(Quality), Time). 

% static casual laws
% % initial states
hold(combustion_engine(0, Quality), 1) :- quality(Quality).

% actions to do
occur(produce(combustion_engine(1000, 1)), 2).
occur(deliver(combustion_engine(500, 1)), 3).
occur(produce(combustion_engine(1, 1)), 4).

#show hold/2.
% #show not_changing/2.