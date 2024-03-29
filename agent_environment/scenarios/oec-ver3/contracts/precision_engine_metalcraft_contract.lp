% clauses id 
clause("C4").
clause("C5").
clause("C6").

% C4: M responsible_for produced(iron_springs,10K) when by_week 4 
hold(sat("C4"), lastTimeStep) :-  hold(produced(iron_springs, 10000), 4). 

% C5: M responsible_for delivered(iron_springs, 10K) when by_week 4
hold(sat("C5"), lastTimeStep) :-  hold(delivered(iron_springs, 10000), 4). 

% C6: P responsible_for payment(iron_springs, 8K) when by_week 4
hold(sat("C6"), lastTimeStep) :-  hold(payment(iron_springs, 8000), 4). 
