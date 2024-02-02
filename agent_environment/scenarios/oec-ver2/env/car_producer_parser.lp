occur_env(speedy_auto_part, receive(A), T)
    :- occur_env(car_producer, pay(vehicle_parts, A), T), time(T).