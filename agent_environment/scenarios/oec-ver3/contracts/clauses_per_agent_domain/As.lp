% clauses id 
% in this form, we assuem that each time() represents a day
clause("C10").
clause("C11").
% clause("C12").

% C10: As responsible_for produced(tool_parts,11K, Q) ∧ 3 ≤ Q when by_week 3 
hold(sat("C10"), T) :-  hold(total_produced_quality, (supplier_of_speedy_auto_parts, (tool_parts, Q, 11000)), T1), Q >= 3, time(T), T1 <= 3.

% C11: As responsible_for delivered(tool_parts,11K, Q) ∧ 3 ≤ Q when by_week 3 
hold(sat("C11"), T) :-  hold(total_delivered_quality, (supplier_of_speedy_auto_parts, (speedy_auto_parts, tool_parts, Q, 11000)), T1), Q >= 3, time(T), T1 <= 3.

% C12: A responsible_for payment(tool_parts, 30K) when by_week 3
% hold(sat("C12"), T) :-  hold(total_received_payment, (supplier_of_speedy_auto_parts, (speedy_auto_parts, tool_parts, 30000)), T1), time(T), T1 <= 3.