good(N) :- N = #count{Clause : hold(Clause, maxStepsConst), clause(Clause)}.
% #maximize {N : good(N)}. 

number(1000).
number(2000).
number(3000).
0{occur(deliver(Amount, Quality), Time) : number(Amount), quality(Quality)}1 :- step(Time). 
0{occur(produce(Amount, Quality), Time) : number(Amount), quality(Quality)}1 :- step(Time). 

% #show hold/2.
#show occur/2.