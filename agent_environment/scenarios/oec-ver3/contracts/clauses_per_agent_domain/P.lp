% clauses id 
% in this form, we assuem that each time() represents a day
clause("C4").
clause("C5").
clause("C6").

% C5: M responsible_for delivered(iron_springs, 10K) when by_week 4
hold(sat("C5"), T) :-  hold(total_received, (precision_engine, (metal_craft_solutions, iron_springs, 10000)), 4), time(T), T >= 4. 

% C6: P responsible_for payment(iron_springs, 8K) when by_week 4
hold(sat("C6"), T) :-  hold(total_sent_payment, (precision_engine, (metal_craft_solutions, iron_springs, 8000)), 4), time(T), T >= 4. 
. 

% contract between car producer and precision engine
clause("C16").
clause("C17").
clause("C18").
%  C16: P responsible_for produced(engines, 90) when by_week 5 
%  C17: P responsible_for delivered(X, engines, 90) when by_week 5 
%  C18: X responsible_for payment(P, sent, engines) when by_week 5 
hold(sat("C16"), T) :-  hold(total_produced, (precision_engine, (engines, 90)), 5), time(T), T >= 5. 

hold(sat("C17"), T) :-  hold(total_delivered, (precision_engine, (car_producer, engines, 90)), 5), time(T), T >= 5. 

hold(sat("C18"), T) :-  hold(total_received_payment, (precision_engine, (car_producer, engines, 30000)), 5), time(T), T >= 5. 
