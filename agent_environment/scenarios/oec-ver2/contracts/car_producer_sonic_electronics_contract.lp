% contract between car producer and sonic electronics
clause("C13").
clause("C14").
clause("C15").

%  C13: E responsible_for produced(radios, 90) when by_week 5 
%  C14: E responsible_for delivered(X, radios, 90) when by_week 5
%  C15: X responsible_for payment(E, sent, radios, 10000) when by_week 5 
hold(sat("C13"), lastTimeStep) :-  hold(produced(radios, 90), 5). 
hold(sat("C14"), lastTimeStep) :-  hold(delivered(car_producer, radios, 90), 5). 
hold(sat("C15"), lastTimeStep) :-  hold(payment(sonic_electronics, sent, radios, 10000), 5).