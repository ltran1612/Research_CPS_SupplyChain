agent(speedy_auto_part).
hold_env(A, F, T) :- hold(F, T), agent(A), time(T).
occur_env(A, B, T) :- occur(B, T), agent(A), time(T).
#show hold_env/3.
#show occur_env/3.

% agent(speedy_auto_part).
% hold_env(speedy_auto_part,vehicle_part(0),0).
% hold_env(speedy_auto_part,money(100000),0).
% hold_env(speedy_auto_part,payment(vehicle_parts,0),0).
% hold_env(speedy_auto_part,delivered(vehicle_parts,0),0).
% hold_env(speedy_auto_part,payment(vehicle_parts,0),1).
% hold_env(speedy_auto_part,money(100000),1).
% hold_env(speedy_auto_part,delivered(vehicle_parts,0),1).
% hold_env(speedy_auto_part,vehicle_part(20000),1).
% occur_env(speedy_auto_part,produce(vehicle_part(20000)),0).

% time(0).
% time(1).
% hold(B, T) :- hold_env(A, B, T), time(T), agent(A).
% occur(B, T) :- occur_env(A, B, T), time(T), agent(A).

% #show hold/2.
% #show occur/2.

