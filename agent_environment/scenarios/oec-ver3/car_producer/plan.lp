time(0..lastTimeStep).
satisfied_clauses_count(N) :- N = #count{Clause : hold(sat(Clause), lastTimeStep), clause(Clause)}.
#maximize {N : satisfied_clauses_count(N)}. 
% base plan script for oec scenario. 

plan_time(A) :- current_time(T), time(A), A >= T.
0 {occur(A, T) : action(A)}1  :- plan_time(T).