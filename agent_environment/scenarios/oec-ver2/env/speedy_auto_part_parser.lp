hold_env(car_producer, notification((speedy_auto_part, T), vehicle_parts, A), T)
    :- occur_env(speedy_auto_part, deliver(vehicle_parts, A), T), time(T).