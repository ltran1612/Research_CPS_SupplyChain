% contract between car producer and sonic electronics
clause("C13").
clause("C14").
clause("C15").

%  C13: E responsible_for produced(radios, 90) when by_week 5 
%  C14: E responsible_for delivered(X, radios, 90) when by_week 5
%  C15: X responsible_for payment(E, sent, radios, 10000) when by_week 5 
hold(sat("C13"), lastTimeStep) :-  hold(produced(radios, 90), 35). 
hold(sat("C14"), lastTimeStep) :-  hold(delivered(car_producer, radios, 90), 35). 
hold(sat("C15"), lastTimeStep) :-  hold(payment(sonic_electronics, received, radios, 10000), 35).

% contract between sonic electronics and the supplier of sonic electronics
clause("C19").
clause("C20").
clause("C21").
%  C19: Es responsible_for produced(electronic_parts, 270) when by_week 10 
%  C20: Es responsible_for delivered(E, electronic_parts, 270) when by_week 10 
%  C21: E responsible_for payment(Es, sent, electronic_parts) when by_week 10 
hold(sat("C20"), lastTimeStep) :-  hold(received(supplier_of_sonic_electronics, electronic_parts, 270), 70). 
hold(sat("C21"), lastTimeStep) :-  hold(payment(supplier_of_sonic_electronics, sent, electronic_parts, 30000), 70). 