% base plan script for oec scenario. 
% planning to pay the item we want to pay for and potentially the delivery fee (if any)
0 {occur(A, T)}1  :- action(A), time(T).