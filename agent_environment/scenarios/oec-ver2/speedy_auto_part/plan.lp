% 
satisfied_clauses_count(N) :- N = #count{Clause : hold(sat(Clause), lastTimeStep), clause(Clause)}.
#maximize {N : satisfied_clauses_count(N)}. 

time(0..lastTimeStep).

% base plan script for oec scenario. 
0 {occur(A, T)}1  :- action(A), time(T).