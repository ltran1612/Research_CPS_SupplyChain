occur_env(car_producer, receive(vehicle_part(A)), T)
    :- occur_env(speedy_auto_part, deliver(vehicle_part(A)), T), time(T).