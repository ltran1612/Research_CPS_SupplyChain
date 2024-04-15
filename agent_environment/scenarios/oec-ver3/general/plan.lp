% base plan script for oec scenario. 
% planning to pay the item we want to pay for and potentially the delivery fee (if any)
0 {occur(Action, Value, T) : action(_, Action, Value)}1  :- time(T).
