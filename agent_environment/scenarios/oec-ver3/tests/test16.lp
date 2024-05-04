% test conjunction 
% expect satisfaction
fluent(a).
fluent(b).
fluent(c).
type(a, conjunction).
member(b, a).
member(c, a).
time(0..10).
:- hold(a, _, T), time(T).

fluent(d).
fluent(e).
fluent(f).
type(d, conjunction).
member(e, a).
member(f, a).
hold(e, (), 0).
hold(f, (), 0).
:- not hold(d, _, T), time(T).