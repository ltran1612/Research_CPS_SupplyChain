% base domain for all agents
% Author: Long Tran
% need to supply the following predicates:
% 1) produce_item(Item): 1 or more.
% 2) deliver_item(Item): 1 or more.
% 3) pay_item(Item): 1 or more, items that we make payment.
% 4) reason(Reason): 0 or more, any reason for payment either receiving payment or make payments. However, if the reason for paying is an item, put it in pay_item instead. This should strictly be used only when we receive payment for items. 
% 5) item(Item): 0 or more, any items that we want to store in the inventory as an agent.
% And any other predicates or laws that are used along with the above, like quality(Quality), and executability laws for produce.
% By default, any pay, deliver, or produce items are an item.
% examples:
% produce_item(wood).
% deliver_item(wood).
% pay_item(saw).

% ITEMS
item(Item) :- deliver_item(Item).
item(Item) :- produce_item(Item).
item(Item) :- pay_item(Item). 
reason(Item) :- pay_item(Item). 

% When we deliver items, we typically want payment for it, so it's part of the reason for payment. 
reason(delivery(Item)) :- deliver_item(Item).
% FLUENTS
fluent(payment(Reason, Amount)) :- number(Amount), reason(Reason).
fluent(available_funds(Amount)) :- number(Amount).
fluent(produced(Item, Amount, Quality)) :- produce_item(Item), number(Amount), quality(Quality). 
fluent(produced(Item, Amount)) :- produce_item(Item), number(Amount). 
fluent(delivered(Item, Amount, Quality)) :- deliver_item(Item), number(Amount), quality(Quality). 
fluent(delivered(Item, Amount)) :- deliver_item(Item), number(Amount).
fluent(available_item(Item, Amount)) :- item(Item), number(Amount).
fluent(available_item(Item, Amount, Quality)) :- item(Item), number(Amount), quality(Quality). 

% ACTIONS
action(pay(Reason, Amount)) :- number(Amount), reason(Reason). 
action(receive_money(Reason, Amount)) :- number(Amount), reason(Reason).
action(receive(Item, Amount)) :- item(Item), number(Amount).
action(receive(Item, Amount, Quality)) :- item(Item), number(Amount), quality(Quality).
action(produce(Item, Amount)) :- produce_item(Item), number(Amount).
action(produce(Item, Amount, Quality)) :- produce_item(Item), number(Amount), quality(Quality).
action(deliver(Item, Amount)) :- deliver_item(Item), number(Amount).
action(deliver(Item, Amount, Quality)) :- deliver_item(Item), number(Amount), quality(Quality).

% DYNAMIC LAWS
% payment
hold(payment(Reason, Amount + OldAmount), T+1) :- hold(payment(Reason, OldAmount), T), occur(pay(Reason, Amount), T).

% available_funds
hold(available_funds(OldAmount - Amount), T+1) :- hold(available_funds(OldAmount), T), OldAmount >= Amount, occur(pay(Reason, Amount), T). 
hold(available_funds(OldAmount + Amount), T+1) :- hold(available_funds(OldAmount), T), occur(receive_money(Reason, Amount), T). 

% receive items 
hold(available_item(Item, Amount + OldAmount), T+1) :- item(Item), hold(available_item(Item, OldAmount), T), occur(receive(Item, Amount), T). 
hold(available_item(Item, Amount + OldAmount, Quality), T+1) :- item(Item), hold(available_item(Item, OldAmount, Quality), T), occur(receive(Item, Amount, Quality), T).

% produce items 
hold(available_item(Item, Amount + OldAmount), T+1) :- produce_item(Item), hold(available_item(Item, OldAmount), T), occur(produce(Item, Amount), T). 
hold(available_item(Item, Amount + OldAmount, Quality), T+1) :- produce_item(Item), hold(available_item(Item, OldAmount, Quality), T), occur(produce(Item, Amount, Quality), T). 
hold(produced(Item, Amount + OldAmount), T+1) :- produce_item(Item), hold(produced(Item, OldAmount), T), occur(produce(Item, Amount), T). 
hold(produced(Item, Amount + OldAmount, Quality), T+1) :- produce_item(Item), hold(produced(Item, OldAmount, Quality), T), occur(produce(Item, Amount, Quality), T). 

% deliver available_item
hold(available_item(Item, OldAmount - Amount), T+1) :- deliver_item(Item), hold(available_item(Item, OldAmount), T), OldAmount >= Amount, occur(deliver(Item, Amount), T).  
hold(available_item(Item, OldAmount - Amount, Quality), T+1) :- deliver_item(Item), hold(available_item(Item, OldAmount, Quality), T), OldAmount >= Amount, occur(deliver(Item, Amount, Quality), T). 
hold(delivered(Item, Amount + OldAmount), T+1) :- deliver_item(Item), hold(delivered(Item, OldAmount), T), occur(deliver(Item, Amount), T). 
hold(delivered(Item, Amount + OldAmount, Quality), T+1) :- deliver_item(Item), hold(delivered(Item, OldAmount, Quality), T), occur(deliver(Item, Amount, Quality), T). 

% EXECUTABILITY LAWS
:- occur(pay(Reason, Amount), T), hold(available_fund(Fund), T), not Fund >= Amount.
:- occur(deliver(Item, Amount), T), hold(available_item(Item, CurrentAmount), T), deliver_item(Item), not CurrentAmount >= Amount.
:- occur(deliver(Item, Amount, Quality), T), hold(available_item(Item, CurrentAmount, Quality), T), deliver_item(Item), not CurrentAmount >= Amount.

% STATIC CASUAL LAWS

% INERTIAL RULES
% not changing stuffs
not_changing(pay(Reason), T) :- not occur(pay(Reason, _), T), reason(Reason), time(T).
not_changing(receive_money(Reason), T) :- not occur(receive_money(Reason, _), T), reason(Reason), time(T).
not_changing(fund, T) :- not_changing(pay(_), T), not_changing(receive_money(_), T).
% 
not_changing(produce(Item), T) :- not occur(produce(Item, _), T), produce_item(Item), time(T).
not_changing(produce(Item, Quality), T) :- not occur(produce(Item, _, Quality), T), produce_item(Item), time(T), quality(Quality).
not_changing(deliver(Item), T) :- not occur(deliver(Item, _), T), deliver_item(Item), time(T).
not_changing(deliver(Item, Quality), T) :- not occur(deliver(Item, _, Quality), T), deliver_item(Item), time(T), quality(Quality).
% item quantity not changing
not_changing(amount(Item), T) :- not_changing(produce(Item), T), not_changing(deliver(Item), T).
not_changing(amount(Item), T) :- not_changing(produce(Item), T), not deliver_item(Item). 
not_changing(amount(Item), T) :- not_changing(deliver(Item), T), not produce_item(Item). 
not_changing(amount(Item, Quality), T) :- not_changing(produce(Item, Quality), T), not_changing(deliver(Item, Quality), T).
not_changing(amount(Item, Quality), T) :- not_changing(produce(Item, Quality), T), not deliver_item(Item, Quality).
not_changing(amount(Item, Quality), T) :- not_changing(deliver(Item, Quality), T), not produce_item(Item, Quality).

% pay
hold(payment(Reason, Amount), T+1) :- hold(payment(Reason, Amount), T), not_changing(pay(Reason), T).
hold(available_funds(Amount), T+1) :- hold(available_funds(Amount), T), not_changing(fund, T).

% producing items
hold(produced(Item, Amount, Quality), T+1) :- hold(produced(Item, Amount, Quality), T), not_changing(produce(Item, Quality), T).
hold(produced(Item, Amount), T+1) :- hold(produced(Item, Amount), T), not_changing(produce(Item), T).

% deliver items
hold(delivered(Item, Amount, Quality), T+1) :- hold(delivered(Item, Amount, Quality), T), not_changing(deliver(Item, Quality), T).
hold(delivered(Item, Amount), T+1) :- hold(delivered(Item, Amount), T), not_changing(deliver(Item), T).

% available items
hold(available_item(Item, Amount), T+1) :- hold(available_item(Item, Amount), T), not_changing(amount(Item), T).
hold(available_item(Item, Amount, Quality), T+1) :- hold(available_item(Item, Amount, Quality), T), not_changing(amount(Item, Quality), T).