% description of when the observation matches the plan 
% if the plan matches the observation, then there is an answer set
% if the plan does not match the observation, then there is no answer set
target_time(T) :- hold(A, T).
max_time(A) :- A = #max{T: target_time(T)}.
non_max_time(T) :- not max_time(T), target_time(T).
% things in plan needs to occur in the observation
:- not hold(A, T), hold_plan(A, T), target_time(T).
:- not occur(A, T), occur_plan(A, T), non_max_time(T). 
% things  in observation needs to be accounted in the plan
:- hold(A, T), not hold_plan(A, T), target_time(T).