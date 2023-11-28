satisfied_clauses_count(N) :- N = #count{Clause : h(sat(Clause), maxStepsConst), clause(Clause)}.
#maximize {N : satisfied_clauses_count(N)}. 

number(50000).
number(25000).
number(25000).
number(40000).
number(1000).
0{occur(pay(Amount, PaymentType), Time) : number(Amount), paymentType(PaymentType)}1 :- step(Time).

% #show h/2.
#show occur/2.
% #show observe/2.