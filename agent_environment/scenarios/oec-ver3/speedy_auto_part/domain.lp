produce_item(vehicle_parts).
deliver_item(car_producer, vehicle_parts).
recv_item(supplier_of_speedy_auto_parts, tool_parts, 1..5).
pay_item(supplier_of_speedy_auto_parts, tool_parts, 1..5).
receiving_reason(car_producer, vehicle_parts).
% base domain for all agents
% Author: Long Tran
% need to supply some of the following predicates:
% 1) produce_item(Item[, Quality]): 1 or more with optional quality.
% 2) deliver_item(Agent, Item)[, Quality]): 1 or more with optional quality with the agent.
% 3) pay_item(Agent, Item[, Quality]): 1 or more, items that we make payment with optional quality with the agent we pay to.
% 4) recv_item(Agent, Item[,Quality]): 0 or more, any items that we receive from other agents with optional quality with the agent we receive from.
% 5) item(Item): 0 or more, any items that we want to store in the inventory as an agent.
% 6) receiving_reason(Agent, Reason): 0 or more, any reason for receiving payment. deliver_item(Item) will lead to a receiving_reason. This will be grouped as payment_reason().
% 7) paying_reason(Agent, Reason): 0 or more, if the reason for paying is an item, put it in pay_item instead. pay_item(...) will create a paying_reason for the item. This will be grouped as payment_reason().
% 8) payment_reason(Agent, Reason): 0 or more, any reason for payment. This is a combination of paying_reason and receiving_reason.
% 8) reason(Reason): 0 or more, the reason for payment, but it is regardless of the agent.
% 9) time(Time): 0 or more, any time that we want to use in the domain. Time has to be able to be advanced by arithmetic +1 in Clingo.
% And any other predicates or laws that are used along with the above, like quality(Quality), and executability laws for produce.
% By default, any pay, deliver, or produce items are an item.
% examples:
% Assumptions: only one action occurs at a time, and the time is discrete.

% RECEIVING FROM AGENTS

% ITEMS
item(Item) :- produce_item(Item).
item(Item, Quality) :- produce_item(Item, Quality).
%
item(Item) :- deliver_item(Agent, Item).
item(Item, Quality) :- deliver_item(Agent, Item, Quality).
%
item(Item) :- pay_item(Agent, Item). 
item(Item, Quality) :- pay_item(Agent, Item, Quality). 
%
item(Item) :- recv_item(Agent, Item). 
item(Item, Quality) :- recv_item(Agent, Item, Quality). 
general_item(Item) :- item(Item).
general_item(Item) :- item(Item, Quality).

% REASONS FOR RECEIPT 
% payment reason for paying to others
paying_reason(Agent, Item) :- pay_item(Agent, Item). 
paying_reason(Agent, Item) :- pay_item(Agent, Item, Quality). 
%
payment_reason(Agent, Reason) :- paying_reason(Agent, Reason).
%
payment_reason(Agent, Reason) :- receiving_reason(Agent, Reason).
%
reason(Reason) :- payment_reason(_, Reason).

% CONSTRAINTS ABOUT THE CUSTOMIZATION 
% same item cannot be both item and item with quality
:- item(Item), item(Item, _).
% the same reason name cannot be both paying reason and receiving reason for an agent.
:- receiving_reason(Agent, Reason), paying_reason(Agent, Reason).
% the receive item cannot be called "payment". It is a reserved word for notification of money.
% the notification of money and the notification of items with quality share the same order of arguments 
:- recv_item(_, payment, _). 

% FLUENTS
fluent(payment(Agent, sent, Reason, Amount)) :- number(Amount), paying_reason(Agent, Reason).
fluent(payment(Agent, received, Reason, Amount)) :- number(Amount), receiving_reason(Agent, Reason).
%
fluent(available_funds(Amount)) :- number(Amount).
%
fluent(produced(Item, Amount, Quality)) :- produce_item(Item, Quality), number(Amount). 
fluent(produced(Item, Amount)) :- produce_item(Item), number(Amount). 
%
fluent(delivered(Agent, Item, Amount, Quality)) :- deliver_item(Agent, Item, Quality), number(Amount). 
fluent(delivered(Agent, Item, Amount)) :- deliver_item(Agent, Item), number(Amount).
%
fluent(received(Agent, Item, Amount, Quality)) :- recv_item(Agent, Item, Quality), number(Amount). 
fluent(received(Agent, Item, Amount)) :- recv_item(Agent, Item), number(Amount).
%
fluent(available_item(Item, Amount)) :- item(Item), number(Amount).
fluent(available_item(Item, Amount, Quality)) :- item(Item, Quality), number(Amount). 
%
fluent(notification((Agent, Time), Item, Amount)) :- number(Amount), time(Time), recv_item(Agent, Item).
fluent(notification((Agent, Time), Item, Amount, Quality)) :- number(Amount), time(Time), recv_item(Agent, Item, Quality).
%
fluent(notification((Agent, Time), payment, Reason, Amount)) :- number(Amount), time(Time), receiving_reason(Agent, Reason).

% ACTIONS
action(pay(Agent, Reason, Amount)) :- number(Amount), paying_reason(Agent, Reason). 
action(receive_money((Agent, Time), Reason, Amount)) :- hold(notification((Agent, Time), payment, Reason, Amount), T), receiving_reason(Agent, Reason). 
action(receive((Agent, Time), Item, Amount)) :- hold(notification((Agent, Time), Item, Amount), T), recv_item(Agent, Item).
action(receive((Agent, Time), Item, Amount, Quality)) :- hold(notification((Agent, Time), Item, Amount, Quality), T), recv_item(Agent, Item, Quality).
action(produce(Item, Amount)) :- produce_item(Item), number(Amount).
action(produce(Item, Amount, Quality)) :- produce_item(Item, Quality), number(Amount).
action(deliver(Agent, Item, Amount)) :- deliver_item(Agent, Item), number(Amount).
action(deliver(Agent, Item, Amount, Quality)) :- deliver_item(Agent, Item, Quality), number(Amount).

% DYNAMIC LAWS
% payment
hold(payment(Agent, sent, Reason, Amount + OldAmount), T+1) :- hold(payment(Agent, sent, Reason, OldAmount), T), occur(pay(Agent, Reason, Amount), T), time(T+1).
% 
hold(payment(Agent, received, Reason, OldAmount + Amount), T+1) :- hold(payment(Agent, received, Reason, OldAmount), T), occur(receive_money((Agent, TimeMark), Reason, Amount), T), time(T+1). 

% available_funds
hold(available_funds(OldAmount - Amount), T+1) :- hold(available_funds(OldAmount), T), OldAmount >= Amount, occur(pay(_, Reason, Amount), T), time(T+1). 
hold(available_funds(OldAmount + Amount), T+1) :- hold(available_funds(OldAmount), T), occur(receive_money(_, Reason, Amount), T), time(T+1). 

% receive items 
hold(available_item(Item, Amount + OldAmount), T+1) :- recv_item(Agent, Item), hold(available_item(Item, OldAmount), T), occur(receive((Agent, TimeMark), Item, Amount), T), time(T+1). 
hold(available_item(Item, Amount + OldAmount, Quality), T+1) :- recv_item(Agent, Item, Quality), hold(available_item(Item, OldAmount, Quality), T), occur(receive((Agent, TimeMark), Item, Amount, Quality), T), time(T+1).
hold(received(Agent, Item, Amount + OldAmount), T+1) :- recv_item(Agent, Item), hold(received(Agent, Item, OldAmount), T), occur(receive((Agent, _), Item, Amount), T), time(T+1). 
hold(received(Agent, Item, Amount + OldAmount, Quality), T+1) :- recv_item(Agent, Item, Quality), hold(received(Agent, Item, OldAmount, Quality), T), occur(receive((Agent, _), Item, Amount, Quality), T), time(T+1). 

% produce items 
hold(available_item(Item, Amount + OldAmount), T+1) :- produce_item(Item), hold(available_item(Item, OldAmount), T), occur(produce(Item, Amount), T), time(T+1). 
hold(available_item(Item, Amount + OldAmount, Quality), T+1) :- produce_item(Item, Quality), hold(available_item(Item, OldAmount, Quality), T), occur(produce(Item, Amount, Quality), T), time(T+1). 
hold(produced(Item, Amount + OldAmount), T+1) :- produce_item(Item), hold(produced(Item, OldAmount), T), occur(produce(Item, Amount), T), time(T+1). 
hold(produced(Item, Amount + OldAmount, Quality), T+1) :- produce_item(Item, Quality), hold(produced(Item, OldAmount, Quality), T), occur(produce(Item, Amount, Quality), T), time(T+1). 

% deliver available_item
hold(available_item(Item, OldAmount - Amount), T+1) :- deliver_item(Agent, Item), hold(available_item(Item, OldAmount), T), OldAmount >= Amount, occur(deliver(Agent, Item, Amount), T), time(T+1).  
hold(available_item(Item, OldAmount - Amount, Quality), T+1) :- deliver_item(Agent, Item, Quality), hold(available_item(Item, OldAmount, Quality), T), OldAmount >= Amount, occur(deliver(Agent, Item, Amount, Quality), T), time(T+1). 
hold(delivered(Agent, Item, Amount + OldAmount), T+1) :- deliver_item(Agent, Item), hold(delivered(Agent, Item, OldAmount), T), occur(deliver(Agent, Item, Amount), T), time(T+1). 
hold(delivered(Agent, Item, Amount + OldAmount, Quality), T+1) :- deliver_item(Agent, Item, Quality), hold(delivered(Agent, Item, OldAmount, Quality), T), occur(deliver(Agent, Item, Amount, Quality), T), time(T+1). 

% EXECUTABILITY LAWS
% cannot pay an amount more than available
:- occur(pay(Agent, Reason, Amount), T), paying_reason(Agent, Reason), hold(available_funds(Fund), T), not Fund >= Amount.
% cannot deliver an amount more than available
:- occur(deliver(Agent, Item, Amount), T), deliver_item(Agent, Item), hold(available_item(Item, CurrentAmount), T), not CurrentAmount >= Amount.
:- occur(deliver(Agent, Item, Amount, Quality), T), deliver_item(Agent, Item, Quality), hold(available_item(Item, CurrentAmount, Quality), T), not CurrentAmount >= Amount.
% cannot deliver an item that is not a deliver item
:- occur(deliver(Agent, Item, Amount), T), not deliver_item(Agent, Item).
:- occur(deliver(Agent, Item, Amount, Quality), T), not deliver_item(Agent, Item, Quality).
% cannot receive item if there is no notification
:- occur(receive((Agent, TimeMark), Item, Amount), T), not hold(notification((Agent, TimeMark), Item, Amount), T). 
:- occur(receive((Agent, TimeMark), Item, Amount, Quality), T), not hold(notification((Agent, TimeMark), Item, Amount, Quality), T). 
% cannot receive item if it is not a recv_item
:- occur(receive((Agent, TimeMark), Item, Amount), T), not recv_item(Agent, Item).
:- occur(receive((Agent, TimeMark), Item, Amount, Quality), T), not recv_item(Agent, Item, Quality).
% cannot receive money if there is no notification
:- occur(receive_money(A, Reason, Amount), T), not hold(notification(A, payment, Reason, Amount), T). 
% cannot receive money if the reason is not a receive reason 
:- occur(receive_money((Agent, TimeMark), Reason, Amount), T), not receiving_reason(Agent, Reason). 
% cannot produce an item that is not a produce item
:- occur(produce(Item, Amount), T), not produce_item(Item). 

% STATIC CASUAL LAWS

% INERTIAL RULES
% auxiliary atoms to determine whether a fluent is changing or not
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
not_done(pay(Agent, Reason), T) :- not occur(pay(Agent, Reason, _), T), paying_reason(Agent, Reason), time(T).
%
changing(fund, T) :- occur(pay(_, _, _), T), time(T).
changing(fund, T) :- occur(receive_money(_, _, _), T), time(T).
not_changing(fund, T) :- not changing(fund, T), time(T).
%
not_changing(money_notification(A, Reason), T) :- A=(Agent, TimeMark), hold(notification(A, payment, Reason, _), T), receiving_reason(Agent, Reason), not occur(receive_money(A, Reason, _), T), time(T).
not_done(receive_money(Agent, Reason), T) :- not occur(receive_money((Agent, _), Reason, _), T), receiving_reason(Agent, Reason), time(T). 
%
not_done(produce(Item), T) :- not occur(produce(Item, _), T), produce_item(Item), time(T).
not_done(produce(Item), T) :- not produce_item(Item), item(Item), time(T). 
%
not_done(produce(Item, Quality), T) :- not occur(produce(Item, _, Quality), T), produce_item(Item, Quality), time(T).
not_done(produce(Item, Quality), T) :- not produce_item(Item, Quality), item(Item, Quality), time(T).
%
not_done(deliver(Agent, Item), T) :- not occur(deliver(Agent, Item, _), T), deliver_item(Agent, Item), time(T).
not_done(deliver(Item), T) :- item(Item), not occur(deliver(_, Item, _), T), time(T).
%
not_done(deliver(Agent, Item, Quality), T) :- not occur(deliver(Agent, Item, _, Quality), T), deliver_item(Agent, Item, Quality), time(T).
not_done(deliver(Item, Quality), T) :- item(Item, Quality), not occur(deliver(_, Item, _, Quality), T), time(T).
%
not_changing(item_notification(A, Item), T) :- A=(Agent, TimeMark), hold(notification(A, Item, Amount), T), recv_item(Agent, Item), not occur(receive(A, Item, Amount), T), time(T).
not_done(receive(Item), T) :- item(Item), not occur(receive(_, Item, _), T), time(T).
not_done(receive(Agent, Item), T) :- recv_item(Agent, Item), not occur(receive((Agent, _), Item, _), T), time(T).
%
not_changing(item_notification(A, Item, Quality), T) :- A=(Agent, TimeMark), hold(notification(A, Item, Amount, Quality), T), recv_item(Agent, Item, Quality), not occur(receive(A, Item, Amount, Quality), T), time(T). 
not_done(receive(Item, Quality), T) :- item(Item, Quality), not occur(receive(_, Item, _, Quality), T), time(T).
not_done(receive(Agent, Item, Quality), T) :- recv_item(Agent, Item, Quality), not occur(receive((Agent, _), Item, _, Quality), T), time(T).
%
% item quantity not changing
not_changing(amount(Item), T) :- not_done(produce(Item), T), not_done(deliver(Item), T), not_done(receive(Item), T).
not_changing(amount(Item, Quality), T) :- not_done(produce(Item, Quality), T), not_done(deliver(Item, Quality), T), not_done(receive(Item, Quality), T).
% end of auxiliary atoms
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% beginning of inertial rules 
% pay
hold(payment(Agent, sent, Reason, Amount), T+1) :- hold(payment(Agent, sent, Reason, Amount), T), not_done(pay(Agent, Reason), T), time(T+1).
hold(payment(Agent, received, Reason, Amount), T+1) :- hold(payment(Agent, received, Reason, Amount), T), not_done(receive_money(Agent, Reason), T), time(T+1).
hold(available_funds(Amount), T+1) :- hold(available_funds(Amount), T), not_changing(fund, T), time(T+1).

% producing items
hold(produced(Item, Amount, Quality), T+1) :- hold(produced(Item, Amount, Quality), T), not_done(produce(Item, Quality), T), time(T+1).
hold(produced(Item, Amount), T+1) :- hold(produced(Item, Amount), T), not_done(produce(Item), T), time(T+1).

% deliver items
hold(delivered(Agent, Item, Amount, Quality), T+1) :- hold(delivered(Agent, Item, Amount, Quality), T), not_done(deliver(Agent, Item, Quality), T), time(T+1).
hold(delivered(Agent, Item, Amount), T+1) :- hold(delivered(Agent, Item, Amount), T), not_done(deliver(Agent, Item), T), time(T+1).

% received items
hold(received(Agent, Item, Amount, Quality), T+1) :- hold(received(Agent, Item, Amount, Quality), T), not_done(receive(Agent, Item, Quality), T), time(T+1).
hold(received(Agent, Item, Amount), T+1) :- hold(received(Agent, Item, Amount), T), not_done(receive(Agent, Item), T), time(T+1).

% available items
hold(available_item(Item, Amount), T+1) :- hold(available_item(Item, Amount), T), not_changing(amount(Item), T), time(T+1).
hold(available_item(Item, Amount, Quality), T+1) :- hold(available_item(Item, Amount, Quality), T), not_changing(amount(Item, Quality), T), time(T+1).

% notifications
hold(notification(A, Item, Amount), T+1) :- hold(notification(A, Item, Amount), T), not_changing(item_notification(A, Item), T), time(T+1).
hold(notification(A, Item, Amount, Quality), T+1) :- hold(notification(A, Item, Amount, Quality), T), not_changing(item_notification(A, Item, Quality), T), time(T+1).
hold(notification(A, payment, Reason, Amount), T+1) :- hold(notification(A, payment, Reason, Amount), T), not_changing(money_notification(A, Reason), T), time(T+1).

% OTHER CONSTRAINTS TO MAKE THE DOMAIN CONSISTENT
% 1) Only one action occurs at a time
:- time(T), occur(A, T), occur(B, T), B != A.
% 2) The (Agent, TimeMark) of notification should be unique
% case for notification with arity of 3. 
:- hold(notification(UniqueKey, _, _), T), not Count1 + Count2 = 1,
Count1=#count{A, B: hold(notification(Key, A, B), T), UniqueKey=Key}, 
Count2=#count{A, B, C: hold(notification(Key, A, B, C), T), UniqueKey=Key}. 
% case for notification with arity of 4. 
:- hold(notification(UniqueKey, _, _, _), T), not Count1 + Count2 = 1,
Count1=#count{A, B: hold(notification(Key, A, B), T), UniqueKey=Key}, 
Count2=#count{A, B, C: hold(notification(Key, A, B, C), T), UniqueKey=Key}. 
% 3) Cannot deliver, produce, receive, or pay negative number of items 
% produce
:- occur(produce(Item, Amount), T), not Amount >= 0.
:- occur(produce(Item, Amount, _), T), not Amount >= 0.
% deliver
:- occur(deliver(_, Item, Amount), T), not Amount >= 0.
:- occur(deliver(_, Item, Amount, _), T), not Amount >= 0.
% pay
:- occur(pay(_, Reason, Amount), T), not Amount >= 0.
% receive
:- occur(receive_money(_, _, Amount), T), not Amount >= 0.
:- occur(receive(_, _, Amount), T), not Amount >= 0.
:- occur(receive(_, _, Amount, _), T), not Amount >= 0.


