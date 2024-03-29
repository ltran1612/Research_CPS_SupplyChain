% base plan script for oec scenario. 
% planning to pay the item we want to pay for and potentially the delivery fee (if any)
plan_time(A) :- current_time(T), time(A), A >= T.
0 {occur(A, T) : action(A)}1  :- plan_time(T).