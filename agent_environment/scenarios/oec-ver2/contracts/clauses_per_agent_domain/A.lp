% clauses 
% clauses id 
% in this form, we assuem that each time() represents a day
clause("C10").
clause("C11").
clause("C12").

% C11: As responsible_for delivered(tool_parts,11K, Q) ∧ 3 ≤ Q when by_week 3 
hold(sat("C11"), lastTimeStep) :-  hold(received(supplier_of_speedy_auto_parts, tool_parts, 11000, Q), 21), Q >= 3. 

% C12: A responsible_for payment(tool_parts, 30K) when by_week 3
hold(sat("C12"), lastTimeStep) :-  hold(payment(supplier_of_speedy_auto_parts, sent, tool_parts, 30000), 21).

% clauses id 
clause("C1").
clause("C2").
clause("C3").

% C1: A responsible_for produced(vehicle_parts, 9K) when by_week 4
hold(sat("C1"), lastTimeStep) :-  hold(produced(vehicle_parts, 9000), 28). 

% C2: A responsible_for delivered(vehicle_parts, 9K) when by_week 4
hold(sat("C2"), lastTimeStep) :-  hold(delivered(car_producer, vehicle_parts, 9000), 28). 

% C3: X responsible_for payment(vehicle_parts, 40K) when by_week 4
hold(sat("C3"), lastTimeStep) :-  hold(payment(car_producer, received, vehicle_parts, 40000), 28). 