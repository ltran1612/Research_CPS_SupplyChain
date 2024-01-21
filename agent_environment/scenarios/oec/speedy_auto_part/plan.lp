% 
satisfied_clauses_count(N) :- N = #count{Clause : hold(sat(Clause), lastTimeStep), clause(Clause)}.
#maximize {N : satisfied_clauses_count(N)}. 

% :- not hold(sat("C2"), lastTimeStep).

0{occur(produce(vehicle_part(Amount)), Time) : number(Amount)}1 
    :- time(Time).
0{occur(deliver(vehicle_part(Amount)), Time) : number(Amount)}1 
    :- time(Time).

% #show hold/2.
#show occur/2.