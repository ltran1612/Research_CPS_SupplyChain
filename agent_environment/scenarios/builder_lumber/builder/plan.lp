% maximum number of steps 
#const maxStepsConst = 10.

% steps declaration
step(0..maxStepsConst).
satisfied_clauses_count(N) :- N = #count{Clause : h(sat(Clause), maxStepsConst), clause(Clause)}.
#maximize {N : satisfied_clauses_count(N)}. 

0{occur(pay(Amount, PaymentType), Time) : number(Amount), paymentType(PaymentType)}1 :- step(Time).

% #show h/2.
#show occur/2.
% #show observe/2.