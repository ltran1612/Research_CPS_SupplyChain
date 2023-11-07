good(N) :- N = #count{Clause : hold(Clause, maxStepsConst), clause(Clause)}.
#maximize {N : good(N)}. 

number(1000).
number(2000).
number(3000).
1{occur(pay(Amount, PaymentType), Time) : number(Amount), paymentType(PaymentType)}1 :- target_step(Time). 

% #show hold/2.
#show occur/2.