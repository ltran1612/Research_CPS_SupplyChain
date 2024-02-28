% clauses id 
clause("C1").
clause("C2").
clause("C3").

% C1: A responsible_for produced(vehicle_parts, 9K) when by_week 4
hold(sat("C1"), lastTimeStep) :-  hold(produced(vehicle_parts, 9000), 4). 

% C2: A responsible_for delivered(vehicle_parts, 9K) when by_week 4
hold(sat("C2"), lastTimeStep) :-  hold(delivered(vehicle_parts, 9000), 4). 

% C3: X responsible_for payment(vehicle_parts, 40K) when by_week 4
hold(sat("C3"), lastTimeStep) :-  hold(payment(vehicle_parts, 40000), 4). 