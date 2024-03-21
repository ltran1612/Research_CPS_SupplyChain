% contract between car producer and precision engine
clause("C16").
clause("C17").
clause("C18").
%  C16: P responsible_for produced(engines, 90) when by_week 5 
%  C17: P responsible_for delivered(X, engines, 90) when by_week 5 
%  C18: X responsible_for payment(P, sent, engines) when by_week 5 
hold(sat("C16"), lastTimeStep) :-  hold(produced(engines, 90), 5).
hold(sat("C17"), lastTimeStep) :-  hold(delivered(car_producer, engines, 90), 5).
hold(sat("C18"), lastTimeStep) :-  hold(payment(precision_engine, sent, engines, 30000), 5).