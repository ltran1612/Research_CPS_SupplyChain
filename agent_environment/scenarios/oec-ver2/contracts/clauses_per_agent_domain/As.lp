% clauses id 
% in this form, we assuem that each time() represents a day
clause("C10").
clause("C11").
clause("C12").

% C10: As responsible_for produced(tool_parts,11K, Q) ∧ 3 ≤ Q when by_week 3 
hold(sat("C10"), lastTimeStep) :-  hold(produced(tool_parts, 11000, Q), 21), Q >= 3. 

% C11: As responsible_for delivered(tool_parts,11K, Q) ∧ 3 ≤ Q when by_week 3 
hold(sat("C11"), lastTimeStep) :-  hold(delivered(speedy_auto_parts, tool_parts, 11000, Q), 21), Q >= 3. 

% C12: A responsible_for payment(tool_parts, 30K) when by_week 3
hold(sat("C12"), lastTimeStep) :-  hold(payment(speedy_auto_parts, received, tool_parts, 30000), 21).