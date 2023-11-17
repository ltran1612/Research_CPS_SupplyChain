satisfied_clauses_count(N) :- N = #count{Clause : hold(sat(Clause), maxStepsConst), clause(Clause)}.
% amount_paid(Amount) :- hold(total_payment(Amount, PaymentType), maxStepsConst), paymentType(PaymentType).
#maximize {N : satisfied_clauses_count(N)}. 
% #minimize {Amount: amount_paid(Amount)}.

number(50000).
number(25000).
number(25000).
number(40000).
number(1000).
0{occur(pay(Amount, PaymentType), Time) : number(Amount), paymentType(PaymentType)}1 :- step(Time).
% :- occur(pay(Y, PaymentType), Time), occur(pay(X, PaymentType), Time), step(Time), paymentType(PaymentType), X!=Y.

% #show hold/2.
#show occur/2.
% #show observe/2.