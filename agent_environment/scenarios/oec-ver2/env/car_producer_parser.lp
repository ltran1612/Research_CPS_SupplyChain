hold_env(speedy_auto_part, notification((car_producer, T), payment, vehicle_parts, A), T)
    :- occur_env(car_producer, pay(vehicle_parts, A), T), time(T).