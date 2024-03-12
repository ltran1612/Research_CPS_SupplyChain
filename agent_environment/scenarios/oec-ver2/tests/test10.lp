% test 10 - test plan pay 
% expect satisfaction
% test state
time(0..10).

pay_item(agent, item).
receiving_reason(agent, reason).
hold(notification((agent, 0), payment, reason, 10), 1).
number(9).
:- not hold(payment(agent, sent, item, 9), 3).