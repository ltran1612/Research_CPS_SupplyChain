satisfied_clauses_count(N) :- N = #count{Clause : hold(sat(Clause), maxStepsConst), clause(Clause)}.
#maximize {N : satisfied_clauses_count(N)}. 

number(1000000).
number(2000).
number(3000).
0{occur(pay(Amount, PaymentType), Time) : number(Amount), paymentType(PaymentType)}1 :- step(Time). 

#show hold/2.
#show occur/2.
#show observe/2.