% clauses id 
clause("C7").
clause("C8").
clause("C9").

% C7: Ms responsible_for produced(titanium_oxide,10K, Q) ∧ 2 ≤ Q when by_week 2
hold(sat("C7"), lastTimeStep) :-  hold(produced(titanium_oxide, 10000, Q), 2), Q >= 2. 

% C8: M responsible_for payment(titanium_oxide, 5K) when by_week 2
hold(sat("C8"), lastTimeStep) :-  hold(payment(titanium_oxide, 5000), 2). 

% C9: Ms responsible_for delivered(titanium_oxide,10K, Q) ∧ 2 ≤ Q when by_week 2
hold(sat("C9"), lastTimeStep) :-  hold(delivered(titanium_oxide, 10000, Q), 2), Q >= 2. 