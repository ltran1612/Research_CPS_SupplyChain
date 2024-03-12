% clauses id 
% in this form, we assuem that each time() represents a day
clause("C4").
clause("C5").
clause("C6").

% C5: M responsible_for delivered(iron_springs, 10K) when by_week 4
hold(sat("C5"), lastTimeStep) :-  hold(received(metal_craft_solutions, iron_springs, 10000), 28). 

% C6: P responsible_for payment(iron_springs, 8K) when by_week 4
hold(sat("C6"), lastTimeStep) :-  hold(payment(metal_craft_solutions, sent, iron_springs, 8000), 28). 
