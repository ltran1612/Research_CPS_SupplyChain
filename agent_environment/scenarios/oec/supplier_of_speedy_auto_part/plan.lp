% 
satisfied_clauses_count(N) :- N = #count{Clause : hold(sat(Clause), lastTimeStep), clause(Clause)}.
#maximize {N : satisfied_clauses_count(N)}. 

time(0..lastTimeStep).

0{occur(produce(tool_part(Amount, Quality)), Time) : number(Amount), quality(Quality)}1 
    :- time(Time).
0{occur(deliver(tool_part(Amount, Quality)), Time) : number(Amount), quality(Quality)}1 
    :- time(Time).

% #show hold/2.
#show occur/2.