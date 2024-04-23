% test error detection with action
% expect satisfaction 
fluent(f1).
time(0..10).

%
hold(f1, v0, 0).
action(env, a, v1).
causes(env, a, v1, f1, o, ()).
action(agent, a, v2).
causes(agent, a, v2, f1, o, ()).

occur(a, (env, v1), 0).
occur(a, (agent, v2), 0).

operation(o, Input, A, T) :- 
    require(o, Input, T),
    Input =  (Agent, a, A, f1, ()),
    time(T).
:- not hold(f1, v0, 0..10). 
:- not failed(1).
:- failed(0).
:- failed(2..10).

