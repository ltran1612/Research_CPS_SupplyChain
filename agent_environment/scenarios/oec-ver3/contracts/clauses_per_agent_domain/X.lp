% clauses id 
% clauses for car producer
% in this form, we assuem that each time() represents a day
% clause("C2").
clause("C3").

% C2: A responsible_for delivered(vehicle_parts, 9K) when by_week 4
% hold(sat("C2"), T) :-  hold(total_received, (car_producer, (speedy_auto_parts, vehicle_parts, 9000)), T1), time(T), T1 <= 4. 

% C3: X responsible_for payment(vehicle_parts, 40K) when by_week 4
hold(sat("C3"), T) :-  hold(total_sent_payment, (car_producer, (speedy_auto_parts, vehicle_parts, 40000)), T1), time(T), T1 <= 4. 

% contract between car producer and precision engine
% clause("C17").
clause("C18").
%  C16: P responsible_for produced(engines, 90) when by_week 5 
%  C17: P responsible_for delivered(X, engines, 90) when by_week 5 
%  C18: X responsible_for payment(P, sent, engines) when by_week 5 
% hold(sat("C17"), T) :-  hold(total_received, (car_producer, (precision_engine, engines, 90)), T1), time(T), T1 <= 5.
hold(sat("C18"), T) :-  hold(total_sent_payment, (car_producer, (precision_engine, engines, 30000)), T1), time(T), T1 <= 5.

% clause("C14").
clause("C15").
%  C13: E responsible_for produced(radios, 90) when by_week 5 
%  C14: E responsible_for delivered(X, radios, 90) when by_week 5
%  C15: X responsible_for payment(E, sent, radios, 10000) when by_week 5 
% hold(sat("C14"), T) :-  hold(total_received, (car_producer, (sonic_electronics, radios, 90)),T1), time(T), T1 <= 5. 
hold(sat("C15"), T) :-  hold(total_sent_payment, (car_producer, (sonic_electronics, radios, 10000)), T1), time(T), T1 <= 5.
% hold(total_sent_payment,(car_producer,(sonic_electronics,radios,11000)),10)
