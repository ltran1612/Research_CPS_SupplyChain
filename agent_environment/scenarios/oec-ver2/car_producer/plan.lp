% plan for car producer 
satisfied_clauses_count(N) :- N = #count{Clause : hold(sat(Clause), lastTimeStep), clause(Clause)}.
#maximize {N : satisfied_clauses_count(N)}. 
 
time(0..lastTimeStep).

0 {occur(pay(Reason, Amount), T) :number(Amount), reason(Reason) } 1 :- time(T). 
0 {occur(receive_money(Reason, Amount), T) :number(Amount), reason(Reason) } 1 :- time(T).

% #show hold/2.
#show occur/2.