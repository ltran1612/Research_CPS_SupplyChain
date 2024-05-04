% test static causal laws
% expect satisfaction
fluent(f1).
fluent(f2).
fluent(f3).
fluent(f4).
type(f3, agent).
type(f4, agent).
time(0..10).

%
caused(env, f1, v1, f2, v2).
hold(f1, v2, 0).
hold(f2, v2, 1).
:- hold(f2, v1, 1..10). 
:- not hold(f2, v2, 1..10). 
:- not hold_attempt(f1, v1, 1). 
:- failed(f1, 1). 
:- not hold(f1, v1, 1..10). 
:- hold(f1, v2, 1..10). 

