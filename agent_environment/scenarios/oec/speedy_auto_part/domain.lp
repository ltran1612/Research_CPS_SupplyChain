% speedy auto parts
% other stuffs
quality(1..3).
% number(1..3).
% time(0..10).

% fluents   
% fluent(iron_spring(X, Quality)) :- number(X), quality(Quality). 
% fluent(inter_tool_part(X)) :- number(X).
% fluent(leather_article(X)) :- number(X).
fluent(vehicle_part(X)) :- number(X).
fluent(money(X)) :- number(X). 
fluent(payment(vehicle_parts, X)) :- number(X). 

% action
action(produce(vehicle_part(X))) :- number(X).
action(deliver(vehicle_part(X))) :- number(X). 
action(pay(X)) :- number(X). 
action(receive(X)) :- number(X). 

% constraints
% :- occur(produce(vehicle_part(A), Time)), 
%     hold(inter_tool_part(Y), Time), 
%     hold(leather_article(Z), Time), 
%     hold(iron_spring(X), Time).

% constraint to only deliver when there is more than enough vehicl part
:- occur(deliver(vehicle_part(A)), Time), 
    hold(vehicle_part(B), Time), 
    A <= B.

% constraint to only pay when there is enough money to pay
:- occur(pay(A), Time), 
    hold(money(B), Time), 
    A <= B.

% dynamic laws
hold(vehicle_part(A+B), Time+1) :- hold(vehicle_part(A), Time), occur(produce(vehicle_part(B)), Time). 
hold(vehicle_part(A-B), Time+1) :- hold(vehicle_part(A), Time), occur(deliver(vehicle_part(B)), Time). 

% pay money
hold(money(A-B), Time+1) :- hold(money(A), Time), occur(pay(B), Time), A >= B.

% receive money
hold(money(A+B), Time+1) :- hold(money(A), Time), occur(receive(B), Time).
hold(payment(vehicle_parts, A+B), Time+1) :- hold(payment(vehicle_parts, A), Time), occur(receive(B), Time).

% inertial laws
not_changing(vehicle_part, Time) :- not occur(produce(vehicle_part(_)), Time), not occur(deliver(vehicle_part(_)), Time), time(Time).
hold(vehicle_part(A), Time+1) :- hold(vehicle_part(A), Time), not_changing(vehicle_part, Time). 

% money
not_receive_money(Time) :- not occur(receive(_), Time), time(Time).
not_changing(money, Time) :- not occur(pay(_), Time), not_receive_money(Time), time(Time).
hold(money(A), Time+1) :- hold(money(A), Time), not_changing(money, Time).
% payment
hold(payment(vehicle_parts, A), Time+1) :- hold(payment(vehicle_parts, A), Time), 
    not_receive_money(Time).

% static casual laws

