satisfied_clauses_count(N) :- N = #count{Clause : hold(sat(Clause), maxStepsConst), clause(Clause)}.
% #maximize {N : satisfied_clauses_count(N)}. 
:- not hold(sat("C2"), maxStepsConst).

number(10000000).
number(2000).
number(3000).
0{occur(deliver(Amount, Quality), Time) : number(Amount), quality(Quality)}1 :- step(Time). 
0{occur(produce(Amount, Quality), Time) : number(Amount), quality(Quality)}1 :- step(Time). 

% #show hold/2.
#show occur/2.
#show satisfied_clauses_count/1.