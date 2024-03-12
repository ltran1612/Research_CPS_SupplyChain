% clauses id 
% clauses for car producer
% in this form, we assuem that each time() represents a day
clause("C1").
clause("C2").
clause("C3").

% C2: A responsible_for delivered(vehicle_parts, 9K) when by_week 4
hold(sat("C2"), lastTimeStep) :-  hold(received(speedy_auto_parts, vehicle_parts, 9000), 28). 

% C3: X responsible_for payment(vehicle_parts, 40K) when by_week 4
hold(sat("C3"), lastTimeStep) :-  hold(payment(speedy_auto_parts, sent, vehicle_parts, 40000), 28). 