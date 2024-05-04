% description of when the observation matches the plan 
% if the plan matches the observation, then there is an answer set
% if the plan does not match the observation, then there is no answer set
target_time(T) :- hold(A, V, T).
max_time(T) :- target_time(T), not target_time(T+1).
non_max_time(T) :- not max_time(T), target_time(T).
% things in plan needs to occur in the observation
:- not hold(F, Value, T), hold_plan(F, Value, T), target_time(T).
:- not occur(Action, Value, T), occur_plan(Action, Value, T), non_max_time(T). 
% things  in observation needs to be accounted in the plan
:- hold(F, Value, T), not hold_plan(F, Value, T), target_time(T).