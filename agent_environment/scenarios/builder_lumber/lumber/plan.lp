satisfied_clauses_count(N) :- N = #count{Clause : hold(sat(Clause), maxStepsConst), clause(Clause)}.
#maximize {N : satisfied_clauses_count(N)}. 
% :- not hold(sat("C1"), maxStepsConst).
% :- not hold(sat("C2"), maxStepsConst).


hold(total_payment(0, board), 0). 
hold(total_payment(0, shipping), 0). 

hold(total_payment(NewAmount, PaymentType), Time+1) :- NewAmount = Current + Amount,
    hold(total_payment(Current, PaymentType), Time),
    observe(payment(Amount, PaymentType), Time),
    step(Time+1)
    .

hold(total_payment(Amount, PaymentType), Time+1) :- step(Time+1),
    hold(total_payment(Amount, PaymentType), Time),
    0=#count{X: observe(payment(X, PaymentType), Time)}
    .

number(60000).
number(20000).
number(10000).
number(5000).
% number(1000).
number(Amount) :- observe(payment(Amount, _), Time). 
number(Amount) :- occur(deliver(Amount, _), Time). 
number(Amount) :- occur(produce(Amount, _), Time). 
% occur(produce(50000, 2), 0).
% occur(produce(50000, 2), 1).
% occur(produce(50000, 2), 2).
% occur(deliver(50000, 2), 1).
% occur(deliver(50000, 2), 2).
% occur(deliver(50000, 2), 3).
% plan the actions
0{occur(deliver(Amount, Quality), Time) : number(Amount), quality(Quality)}1 :- step(Time). 
0{occur(produce(Amount, Quality), Time) : number(Amount), quality(Quality)}1 :- step(Time). 

% make assumptions
% observe(payment(1000, board), 1).
% observe(payment(1000, board), 2).
% observe(payment(1000, board), 3).
% observe(payment(1000, board), 4).
% 0{observe(payment(Amount, PaymentType), Time) : number(Amount), paymentType(PaymentType)}1 :- step(Time).

% condition to continue doing actions
% :- hold(total_payment(Amount, board), 3), not Amount >= 100000.

#show hold/2.
#show occur/2.
#show observe/2.
#show satisfied_clauses_count/1.