% base plan script for oec scenario. 
% planning to pay the item we want to pay for and potentially the delivery fee (if any)
% satisfied_clauses_count(N) :- N = #count{Clause : hold(sat(Clause), lastTimeStep), clause(Clause)}.
% #maximize {N : satisfied_clauses_count(N)}. 

% time(0..lastTimeStep).
% #const lastTimeStep = 6.
0 {occur(Action, Value, T) : action(_, Action, Value)}1  :- time(T).
% number(8500).
% number(500).
% number(1000).
% number(500).
% #show occur/3.
% #show action/3. 
#show occur(Action, Value, T) : occur(Action, Value, T), not failed(Action, Value, T).
#show.
% #show action/3.