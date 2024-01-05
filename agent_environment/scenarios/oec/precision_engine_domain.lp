% domain for Precision Engine
% other stuffs
quality(1..3).
time(1..10).
number(1..3).

% fluents 
fluent(combustion_engine(X, Quality)) :- number(X), quality(Quality).

% actions
action(produce(combustion_engine(X, Quality), Time)) :- number(X), quality(Quality), time(Time).
action(deliver(combustion_engine(X, Quality), Time)) :- number(X), quality(Quality), time(Time). 

% dynamic laws
hold(combustion_engine(A+B), Time+1) :- hold(combustion_engine(A), Time), occur(produce(combustion_engine(B)), Time). 
hold(combustion_engine(A-B), Time+1) :- hold(combustion_engine(A), Time), occur(deliver(combustion_engine(B)), Time). 

% inertial laws
not_changing(combustion_engine, Time) :- not occur(produce(combustion_engine(_)), Time), not occur(deliver(combustion_engine(_)), Time), time(Time).
hold(combustion_engine(A), Time+1) :- hold(combustion_engine(A), Time), not_changing(combustion_engine, Time). 

% static casual laws

% initial states
hold(combustion_engine(0), 1).

% actions to do
occur(produce(combustion_engine(1000)), 1).
occur(deliver(combustion_engine(1000)), 3).

#show hold/2.
% #show not_changing/2.