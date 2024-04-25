% clauses 
% clauses id 
% in this form, we assuem that each time() represents a day
% clause("C11").
clause("C12").

% C11: As responsible_for delivered(tool_parts,11K, Q) ∧ 3 ≤ Q when by_week 3 
% hold(sat("C11"), T) :-  hold(total_received_quality, (speedy_auto_parts, (supplier_of_speedy_auto_parts, tool_parts, Q, 11000)), 3), Q >= 3, time(T), T >= 3.

% C12: A responsible_for payment(tool_parts, 30K) when by_week 3
hold(sat("C12"), T) :-  hold(total_sent_payment, (speedy_auto_parts, (supplier_of_speedy_auto_parts,  tool_parts, 30000)), T1), time(T), T1 <= 3.

% clauses id 
clause("C1").
clause("C2").
% clause("C3").

% C1: A responsible_for produced(vehicle_parts, 9K) when by_week 4
hold(sat("C1"), T) :-  hold(total_produced, (speedy_auto_parts, (vehicle_parts, Amount)), T1), time(T), T1 <= 4, Amount >= 9000.

% C2: A responsible_for delivered(vehicle_parts, 9K) when by_week 4
hold(sat("C2"), T) :-  hold(total_delivered, (speedy_auto_parts, (car_producer, vehicle_parts, Amount)), T1), time(T1), time(T), T1 <= 4, Amount >= 9000. 

% C3: X responsible_for payment(vehicle_parts, 40K) when by_week 4
% hold(sat("C3"), T) :-  hold(total_received_payment, (speedy_auto_parts, (car_producer, vehicle_parts, Amount)), T1), time(T1), time(T), T1 <= 4, Amount >= 40000. 