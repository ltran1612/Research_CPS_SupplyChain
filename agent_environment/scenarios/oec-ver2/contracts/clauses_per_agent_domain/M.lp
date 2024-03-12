% clauses id 
% in this form, we assuem that each time() represents a day
clause("C7").
clause("C8").
clause("C9").

% C8: M responsible_for payment(titanium_oxide, 5K) when by_week 2
hold(sat("C8"), lastTimeStep) :-  hold(payment(supplier_of_metal_craft_solutions, sent, titanium_oxide, 5000), 14). 

% C9: Ms responsible_for delivered(titanium_oxide,10K, Q) ∧ 2 ≤ Q when by_week 2
hold(sat("C9"), lastTimeStep) :-  hold(received(supplier_of_metal_craft_solutions, titanium_oxide, 10000, Q), 14), Q >= 2. 

% clauses id 
clause("C4").
clause("C5").
clause("C6").

% C4: M responsible_for produced(iron_springs,10K) when by_week 4 
hold(sat("C4"), lastTimeStep) :-  hold(produced(iron_springs, 10000), 28). 

% C5: M responsible_for delivered(iron_springs, 10K) when by_week 4
hold(sat("C5"), lastTimeStep) :-  hold(delivered(precision_engine, iron_springs, 10000), 28). 

% C6: P responsible_for payment(iron_springs, 8K) when by_week 4
hold(sat("C6"), lastTimeStep) :-  hold(payment(precision_engine, received, iron_springs, 8000), 28). 
