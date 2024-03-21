% clauses id 
% in this form, we assuem that each time() represents a day
clause("C4").
clause("C5").
clause("C6").

% C5: M responsible_for delivered(iron_springs, 10K) when by_week 4
hold(sat("C5"), lastTimeStep) :-  hold(received(metal_craft_solutions, iron_springs, 10000), 28). 

% C6: P responsible_for payment(iron_springs, 8K) when by_week 4
hold(sat("C6"), lastTimeStep) :-  hold(payment(metal_craft_solutions, sent, iron_springs, 8000), 28). 

% contract between car producer and precision engine
clause("C16").
clause("C17").
clause("C18").
%  C16: P responsible_for produced(engines, 90) when by_week 5 
%  C17: P responsible_for delivered(X, engines, 90) when by_week 5 
%  C18: X responsible_for payment(P, sent, engines) when by_week 5 
hold(sat("C16"), lastTimeStep) :-  hold(produced(engines, 90), 35).
hold(sat("C17"), lastTimeStep) :-  hold(delivered(car_producer, engines, 90), 35).
hold(sat("C18"), lastTimeStep) :-  hold(payment(car_producer, received, engines, 30000), 35).