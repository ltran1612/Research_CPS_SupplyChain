% contract between car producer and sonic electronics
clause("C13").
clause("C14").
% clause("C15").

%  C13: E responsible_for produced(radios, 90) when by_week 5 
%  C14: E responsible_for delivered(X, radios, 90) when by_week 5
%  C15: X responsible_for payment(E, sent, radios, 10000) when by_week 5 
hold(sat("C13"), T) :-  hold(total_produced, (sonic_electronics, (radios, 90)), T1), time(T), T1 <= 5. 
hold(sat("C14"), T) :-  hold(total_delivered, (sonic_electronics, (car_producer, radios, 90)), T1), time(T), T <= 5. 
% hold(sat("C15"), T) :-  hold(total_received_payment, (sonic_electronics, (car_producer,radios, 10000)), T1), time(T), T1 <= 5.

% contract between sonic electronics and the supplier of sonic electronics
% clause("C20").
clause("C21").
%  C19: Es responsible_for produced(electronic_parts, 270) when by_week 10 
%  C20: Es responsible_for delivered(E, electronic_parts, 270) when by_week 10 
%  C21: E responsible_for payment(Es, sent, electronic_parts) when by_week 10 
% hold(sat("C20"), T) :-  hold(total_received, (sonic_electronics, (supplier_of_sonic_electronics, electronic_parts, 270)), T1), time(T), T <= 10. 
hold(sat("C21"), T) :-  hold(total_sent_payment, (sonic_electronics, (supplier_of_sonic_electronics, electronics_parts, 30000)), T1), time(T), T1 <= 10. 