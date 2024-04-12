% clauses 
% clauses id 

% clauses id 
clause("C1").
clause("C2").

% C1: A responsible_for produced(vehicle_parts, 9K) when by_week 4
hold(sat("C1"), lastTimeStep) :-  hold(total_produced, (speedy_auto_parts, (vehicle_parts, 9000)), 5). 

% C2: A responsible_for delivered(vehicle_parts, 9K) when by_week 4
hold(sat("C2"), lastTimeStep) :-  hold(total_delivered, (speedy_auto_parts, (car_producer, vehicle_parts, 9000)), 5). 
