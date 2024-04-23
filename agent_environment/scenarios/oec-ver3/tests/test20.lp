% test error detection
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

% test the failed detection
% this second causal law caused conflicts to happen
% in that case, we just try to carry on from the previous states
caused(env, f1, v3, f3, (a, v2)).
hold(f3, (a, v2), 2).
hold(f4, (a, v2), 2).
:- not hold(f3, (a, v2), 2..10). 
:- not hold(f4, (a, v2), 2..10). 
:- not hold(f1, v1, 2..10). 
:- not failed(f1, 2..10).
