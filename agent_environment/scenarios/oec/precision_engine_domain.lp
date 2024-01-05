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