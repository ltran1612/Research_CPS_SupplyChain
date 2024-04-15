time(0..3).
satisfied_clauses_count(N) :- N = #count{Clause : hold(sat(Clause), lastTimeStep), clause(Clause)}.
#maximize {N : satisfied_clauses_count(N)}. 
% base plan script for oec scenario. 

plan_time(A) :- current_time(T), time(A), A >= T.
% base plan script for oec scenario. 
% planning to pay the item we want to pay for and potentially the delivery fee (if any)
0 {occur(Action, (Agent, Value), T) : action(Agent, Action, Value)}1  :- plan_time(T).