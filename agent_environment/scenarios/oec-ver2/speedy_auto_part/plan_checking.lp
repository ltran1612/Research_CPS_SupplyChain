target_time(T) :- hold(A, T).
:- not hold(A, T), hold_plan(A, T), target_time(T).
:- not occur(A, T), occur_plan(A, T), target_time(T). 
% #show time/1.
% #show.
% #show plan(A): hold_plan(A, T), time(T).
% #show obs(A): hold(A, T), time(T).
% #show diff(A): not hold(A, T), hold_plan(A, T), time(T).
