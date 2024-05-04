% clauses id 
clause("C7").
clause("C8").
clause("C9").

% C7: Ms responsible_for produced(titanium_oxide,10K, Q) ∧ 2 ≤ Q when by_week 2
hold(sat("C7"), lastTimeStep) :-  hold(produced(titanium_oxide, 10000, Q), 14), Q >= 2. 

% C8: M responsible_for payment(titanium_oxide, 5K) when by_week 2
hold(sat("C8"), lastTimeStep) :-  hold(payment(metal_craft_solutions, received, titanium_oxide, 5000), 14). 

% C9: Ms responsible_for delivered(titanium_oxide,10K, Q) ∧ 2 ≤ Q when by_week 2
hold(sat("C9"), lastTimeStep) :-  hold(delivered(metal_craft_solutions, titanium_oxide, 10000, Q), 14), Q >= 2. 