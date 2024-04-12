% clauses id 
% clauses for car producer
% in this form, we assuem that each time() represents a day
clause("C1").
clause("C2").
clause("C3").

% C2: A responsible_for delivered(vehicle_parts, 9K) when by_week 4
hold(sat("C2"), lastTimeStep) :-  hold(total_received, (car_producer, speedy_auto_parts, vehicle_parts, 9000), 28). 

% C3: X responsible_for payment(vehicle_parts, 40K) when by_week 4
hold(sat("C3"), lastTimeStep) :-  hold(sent_payment, (car_producer, speedy_auto_parts, sent, vehicle_parts, 40000), 28). 

% contract between car producer and precision engine
clause("C16").
clause("C17").
clause("C18").
%  C16: P responsible_for produced(engines, 90) when by_week 5 
%  C17: P responsible_for delivered(X, engines, 90) when by_week 5 
%  C18: X responsible_for payment(P, sent, engines) when by_week 5 
hold(sat("C17"), lastTimeStep) :-  hold(received(car_producer, engines, 90), 35).
hold(sat("C18"), lastTimeStep) :-  hold(payment(precision_engine, sent, engines, 30000), 35).

%  C13: E responsible_for produced(radios, 90) when by_week 5 
%  C14: E responsible_for delivered(X, radios, 90) when by_week 5
%  C15: X responsible_for payment(E, sent, radios, 10000) when by_week 5 
hold(sat("C14"), lastTimeStep) :-  hold(received(sonic_electronics, radios, 90), 35). 
hold(sat("C15"), lastTimeStep) :-  hold(payment(sonic_electronics, sent, radios, 10000), 35).