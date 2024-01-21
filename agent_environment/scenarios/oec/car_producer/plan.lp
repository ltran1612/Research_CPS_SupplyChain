% maximum number of steps 
#const maxTime = 10.

% time declaration
time(0..maxTime).

% numbers
number(1000).

% 
satisfied_clauses_count(N) :- N = #count{Clause : hold(sat(Clause), maxTime), clause(Clause)}.
#maximize {N : satisfied_clauses_count(N)}. 

0{occur(pay(vehicle_parts, Amount), Time) : number(Amount), paymentType(PaymentType)}1 
    :- step(Time).

% #show hold/2.
#show occur/2.