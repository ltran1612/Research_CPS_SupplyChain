% contract between sonic electronics and the supplier of sonic electronics
clause("C19").
clause("C20").
clause("C21").
%  C19: Es responsible_for produced(electronic_parts, 270) when by_week 10 
%  C20: Es responsible_for delivered(E, electronic_parts, 270) when by_week 10 
%  C21: E responsible_for payment(Es, sent, electronic_parts) when by_week 10 
hold(sat("C19"), T) :-  hold(total_produced, (supplier_of_sonic_electronics, (electronic_parts, 270)), 10), time(T), T >= 10.
hold(sat("C20"), T) :-  hold(total_delivered, (supplier_of_sonic_electronics, (sonic_electronics, electronic_parts, 270)), 10), time(T), T >= 10. 
hold(sat("C21"), T) :-  hold(total_received_payment, (supplier_of_sonic_electronics, (electronic_parts, 30000)), 10), time(T), T >= 10. 