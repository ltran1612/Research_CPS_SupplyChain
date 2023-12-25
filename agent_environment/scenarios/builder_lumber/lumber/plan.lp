% maximum number of steps 
#const maxStepsConst = 10.

% steps declaration
step(0..maxStepsConst).

satisfied_clauses_count(N) :- N = #count{Clause : h(sat(Clause), maxStepsConst), clause(Clause)}.
#maximize {N : satisfied_clauses_count(N)}. 
% :- not h(sat("C1"), maxStepsConst).
% :- not h(sat("C2"), maxStepsConst).


h(total_payment(0, board), 0). 
h(total_payment(0, shipping), 0). 

h(total_payment(NewAmount, PaymentType), Time+1) :- NewAmount = Current + Amount,
    h(total_payment(Current, PaymentType), Time),
    observe(payment(Amount, PaymentType), Time),
    step(Time+1)
    .

h(total_payment(Amount, PaymentType), Time+1) :- step(Time+1),
    h(total_payment(Amount, PaymentType), Time),
    0=#count{X: observe(payment(X, PaymentType), Time)}
    .

% plan the actions
0{occur(deliver(Amount, Quality), Time) : number(Amount), quality(Quality)}1 :- step(Time). 
0{occur(produce(Amount, Quality), Time) : number(Amount), quality(Quality)}1 :- step(Time). 

#show h/2.
#show occur/2.
#show observe/2.
#show satisfied_clauses_count/1.