hold_env(speedy_auto_part, notification((car_producer, T), payment, vehicle_parts, A), T)
    :- occur_env(car_producer, pay(vehicle_parts, A), T), time(T).
hold_env(car_producer, notification((speedy_auto_part, T), vehicle_parts, A), T)
    :- occur_env(speedy_auto_part, deliver(vehicle_parts, A), T), time(T).
hold_env(speedy_auto_part, notification((supplier_of_speedy_auto_part, speedy_auto_part, T), tool_parts, A, Q), T)
    :- occur_env(supplier_of_speedy_auto_part, deliver(tool_parts, A, Q), T), time(T).