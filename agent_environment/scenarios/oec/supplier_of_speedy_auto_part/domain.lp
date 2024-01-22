% supplier of speedy auto parts
quality(1..3).

% fluents   
fluent(tool_part(X, Q)) :- number(X), quality(Q).
fluent(payment(tool_parts, X)) :- number(X). 
fluent(delivered(tool_parts, X, Q)) :- number(X), quality(Q). 

% action
action(produce(tool_part(X, Q))) :- number(X), quality(Q).
action(deliver(tool_part(X, Q))) :- number(X), quality(Q).

% constraints
hold(tool_part(A+B, Q), Time+1) :- hold(tool_part(A, Q), Time), occur(produce(tool_part(B, Q)), Time), time(Time+1). 
hold(tool_part(A-B, Q), Time+1) :- hold(tool_part(A, Q), Time), occur(deliver(tool_part(B, Q)), Time), time(Time+1). 
hold(delivered(tool_parts, A+B, Q), Time+1) :- hold(delivered(tool_parts, A, Q), Time), occur(deliver(tool_part(B, Q)), Time), time(Time+1). 

% receive money
hold(money(A+B), Time+1) :- hold(money(A), Time), occur(receive(B), Time), time(Time+1).
hold(payment(tool_parts, A+B), Time+1) :- hold(payment(tool_parts, A), Time), occur(receive(B), Time), time(Time+1).

% inertial laws
% vehicle part
no_delivery(Q, Time) :- not occur(deliver(tool_part(_, Q)), Time), time(Time), time(Time+1), quality(Q).
not_changing(tool_part(Q), Time) :- not occur(produce(tool_part(_, Q)), Time), no_delivery(Q, Time), time(Time+1), quality(Q). 
hold(tool_part(A, Q), Time+1) :- hold(tool_part(A, Q), Time), not_changing(tool_part(Q), Time), time(Time+1). 

% delivered
hold(delivered(tool_parts, A, Q), Time+1) :- hold(delivered(tool_parts, A, Q), Time), 
    no_delivery(Q, Time), time(Time+1).

% money
not_receive_money(Time) :- not occur(receive(_), Time), time(Time).
hold(money(A), Time+1) :- hold(money(A), Time), not_receive_money(Time), time(Time+1).
% payment
hold(payment(tool_parts, A), Time+1) :- hold(payment(tool_parts, A), Time), 
    not_receive_money(Time), time(Time+1).
