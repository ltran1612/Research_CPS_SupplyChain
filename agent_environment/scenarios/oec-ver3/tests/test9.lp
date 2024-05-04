% test 9 - test plan receive money 
% expect satisfaction
% test state
time(0..10).

receiving_reason(agent, reason).
hold(notification((agent, 0), payment, reason, 9), 1).
:- not hold(payment(agent, received, reason, 9), 2).