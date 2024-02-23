target_time(T) :- hold(A, T).
max_time(A) :- A = #max{T: target_time(T)}.
non_max_time(T) :- not max_time(T), target_time(T).

:- not hold(A, T), hold_plan(A, T), target_time(T).
:- not occur(A, T), occur_plan(A, T), non_max_time(T). 
% #show time/1.
% #show.
% #show plan(A): hold_plan(A, T), time(T).
% #show obs(A): hold(A, T), time(T).
% #show target_time/1.
