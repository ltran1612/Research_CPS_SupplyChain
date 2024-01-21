% 
satisfied_clauses_count(N) :- N = #count{Clause : hold(sat(Clause), lastTimeStep), clause(Clause)}.
#maximize {N : satisfied_clauses_count(N)}. 
 

0{occur(pay(vehicle_parts, Amount), Time) : number(Amount)}1 
    :- time(Time).

% #show hold/2.
#show occur/2.