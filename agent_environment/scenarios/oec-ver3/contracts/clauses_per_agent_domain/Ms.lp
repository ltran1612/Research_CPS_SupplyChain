% clauses id 
clause("C7").
clause("C8").
clause("C9").

% C7: Ms responsible_for produced(titanium_oxide,10K, Q) ∧ 2 ≤ Q when by_week 2
hold(sat("C7"), T) :-  hold(total_produced_quality, (supplier_of_metal_craft_solutions, (titanium_oxide, Q, 10000)), 2), Q >= 2, time(T), T >= 2. 

% C8: M responsible_for payment(titanium_oxide, 5K) when by_week 2
hold(sat("C8"), T) :-  hold(total_received_payment, (supplier_of_metal_craft_solutions, (metal_craft_solutions, titanium_oxide, 5000)), 2), time(T), T >= 2.

% C9: Ms responsible_for delivered(titanium_oxide,10K, Q) ∧ 2 ≤ Q when by_week 2
hold(sat("C9"), T) :-  hold(total_delivered_quality, (supplier_of_metal_craft_solutions, (metal_craft_solutions, titanium_oxide, Q, 10000)), 2), Q >= 2, time(T), T >= 2.