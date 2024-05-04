% produce_item(tester, A) :- produce_item(A).
% produce_item(tester, A, B) :- produce_item(A, B).
% deliver_item(tester, A, B) :- deliver_item(A, B).
% deliver_item(tester, A, B, C) :- deliver_item(A, B, C).
% pay_item(tester, A, B) :- pay_item(A, B).
% pay_item(tester, A, B, C) :- pay_item(A, B, C).
% recv_item(tester, A, B) :- recv_item(A, B).
% recv_item(tester, A, B, C) :- recv_item(A, B, C).

% action(tester, produce, (tester, Item, Amount)) :- occur(produce(Item, Amount), Time).
% occur(produce, (tester, Item, Amount), Time) :- occur(produce(Item, Amount), Time).
#show hold/3.
% #show changed/5.
% #show occur/3.
% #show require/3.
% #show operation/4.
% #show time/1.
% #show causes/6.
% #show action/3.
action(tester, produce, (tester, wood, 100)).
produce_item(tester, wood).
time(0..2).
occur(produce, (tester, wood, 100), 0).
