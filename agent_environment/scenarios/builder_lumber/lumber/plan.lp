satisfied_clauses_count(N) :- N = #count{Clause : hold(sat(Clause), maxStepsConst), clause(Clause)}.
#maximize {N : satisfied_clauses_count(N)}. 
% :- not hold(sat("C1"), maxStepsConst).
% :- not hold(sat("C2"), maxStepsConst).

number(60000).
number(20000).
number(10000).
number(5000).
% occur(produce(50000, 2), 0).
% occur(produce(50000, 2), 1).
% occur(produce(50000, 2), 2).
% occur(deliver(50000, 2), 1).
% occur(deliver(50000, 2), 2).
% occur(deliver(50000, 2), 3).
0{occur(deliver(Amount, Quality), Time) : number(Amount), quality(Quality)}1 :- step(Time). 
0{occur(produce(Amount, Quality), Time) : number(Amount), quality(Quality)}1 :- step(Time). 

% #show hold/2.
#show occur/2.
% #show satisfied_clauses_count/1.