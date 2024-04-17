produce_item(supplier_of_sonic_electronics, electronics_parts).
deliver_item(supplier_of_sonic_electronics, sonic_electronics, electronics_parts).
receiving_reason(supplier_of_sonic_electronics, sonic_electronics, electronics_parts).
%
needs(Agent, delivered, FromAgent) :- recv_item(Agent, FromAgent, Item). 
needs(Agent, delivered_quality, FromAgent) :- recv_item(Agent, FromAgent, Item, Quality).
needs(Agent, sent_payment, FromAgent) :- receiving_reason(Agent, FromAgent, Reason). 

% RECEIVING FROM AGENTS
% ITEMS
item(Agent, Item) :- produce_item(Agent, Item).
item(Agent, Item, Quality) :- produce_item(Agent, Item, Quality).
%
item(Agent, Item) :- deliver_item(Agent, ToAgent, Item).
item(Agent, Item, Quality) :- deliver_item(Agent, ToAgent, Item, Quality).
%
item(Agent, Item) :- pay_item(Agent, ToAgent, Item). 
item(Agent, Item, Quality) :- pay_item(Agent, ToAgent, Item, Quality). 
%
item(Agent, Item) :- recv_item(Agent, FromAgent, Item). 
item(Agent, Item, Quality) :- recv_item(Agent, FromAgent, Item, Quality). 
general_item(Agent, Item) :- item(Agent, Item).
general_item(Agent, Item) :- item(Agent, Item, Quality).

% REASONS FOR RECEIPT 
% payment reason for paying to others
paying_reason(Agent, ToAgent, Item) :- pay_item(Agent, ToAgent, Item). 
paying_reason(Agent, ToAgent, Item) :- pay_item(Agent, ToAgent, Item, Quality). 
%
payment_reason(Agent, ToAgent, Reason) :- paying_reason(Agent, ToAgent, Reason).
%
payment_reason(Agent, FromAgent, Reason) :- receiving_reason(Agent, FromAgent, Reason).
%
reason(Agent, Reason) :- payment_reason(Agent, _, Reason).

% CONSTRAINTS ABOUT THE CUSTOMIZATION 
% same item cannot be both item and item with quality
:- item(Agent, Item), item(Agent, Item, _).
% the same reason name cannot be both paying reason and receiving reason for an agent.
:- receiving_reason(Agent, FromAgent, Reason), paying_reason(Agent, FromAgent, Reason).
% the receive item cannot be called "payment". It is a reserved word for notification of money.
% the notification of money and the notification of items with quality share the same order of arguments 
:- recv_item(_, payment, _). 

% ACTIONS
action(Agent, pay, (ToAgent, Reason, Amount)) :- number(Amount), paying_reason(Agent, ToAgent, Reason). 
% TODO
action(Agent, receive_money, (FromAgent, Time, Reason, Amount)) :- hold(sent_payment, (FromAgent, (Agent, Time, Reason, Amount)), _), receiving_reason(Agent, FromAgent, Reason). 
action(Agent, receive, (FromAgent, Time, Item, Amount)) :- hold(delivered, (FromAgent, (Agent, Time, Item, Amount)), _), recv_item(Agent, FromAgent, Item).
action(Agent, receive_quality, (FromAgent, Time, Item, Quality, Amount)) :- hold(delivered_quality, (FromAgent, (Agent, Time, Item, Quality, Amount)), _), recv_item(Agent, FromAgent, Item, Quality).
%
action(Agent, produce, (Item, Amount)) :- produce_item(Agent, Item), number(Amount).
action(Agent, produce_quality, (Item, Quality, Amount)) :- produce_item(Agent, Item, Quality), number(Amount).
action(Agent, deliver, (ToAgent, Item, Amount)) :- deliver_item(Agent, ToAgent, Item), number(Amount).
action(Agent, deliver_quality, (ToAgent, Item, Quality, Amount)) :- deliver_item(Agent, ToAgent, Item, Quality), number(Amount).

% DYNAMIC LAWS
% payment
% pay money
causes(Agent, pay, Value, total_sent_payment, increase, ()) :- action(Agent, pay, Value).
causes(Agent, pay, Value, available_funds, decrease, ()) :- action(Agent, pay, Value).
causes(Agent, pay, Value, sent_payment, record, ()) :- action(Agent, pay, Value).
% receive payment 
causes(Agent, receive_money, Value, total_received_payment, increase, ()) :- action(Agent, receive_money, Value).
causes(Agent, receive_money, Value, available_funds, increase, ()) :- action(Agent, receive_money, Value).
% receive items
causes(Agent, receive, Value, available_item, increase, ()) :- action(Agent, receive, Value).
causes(Agent, receive, Value, total_received, increase, ()) :- action(Agent, receive, Value).
causes(Agent, receive, Value, received, record, ()) :- action(Agent, receive, Value).
%
causes(Agent, receive_quality, Value, available_quality_item, increase, ()) :- action(Agent, receive_quality, Value).
causes(Agent, receive_quality, Value, total_received_quality, increase, ()) :- action(Agent, receive_quality, Value).
causes(Agent, receive, Value, received_quality, record, ()) :- action(Agent, receive, Value).
% produce
causes(Agent, produce, Value, available_item, increase, ()) :- action(Agent, produce, Value).
causes(Agent, produce, Value, total_produced, increase, ()) :- action(Agent, produce, Value).
%
causes(Agent, produce_quality, Value, available_quality_item, increase, ()) :- action(Agent, produce_quality, Value).
causes(Agent, produce_quality, Value, total_produced_quality, increase, ()) :- action(Agent, produce_quality, Value).
% deliver
causes(Agent, deliver, Value, available_item, decrease, ()) :- action(Agent, deliver, Value).
causes(Agent, deliver, Value, total_delivered, increase, ()) :- action(Agent, deliver, Value).
causes(Agent, deliver, Value, delivered, record, ()) :- action(Agent, deliver, Value).
%
causes(Agent, deliver_quality, Value, available_quality_item, decrease, ()) :- action(Agent, deliver_quality, Value).
causes(Agent, deliver_quality, Value, total_delivered_quality, increase, ()) :- action(Agent, deliver_quality, Value).
causes(Agent, deliver_quality, Value, delivered_quality, record, ()) :- action(Agent, deliver_quality, Value).

% static causal laws

% executable LAWS
% conditions
% cannot pay an amount more than available
executable(Agent, pay, Value, enough_funds) :- action(Agent, pay, Value).
satisfy_condition(Agent, enough_funds, greater, (pay, Value, available_funds)) :- action(Agent, pay, Value).
% cannot deliver an amount more than available
executable(Agent, deliver, Value, enough_item) :- action(Agent, deliver, Value). 
satisfy_condition(Agent, enough_item, greater, (deliver, Value, available_item)) :- action(Agent, deliver, Value). 
%
executable(Agent, deliver_quality, Value, enough_item_quality) :- action(Agent, deliver_quality, Value).
satisfy_condition(Agent, enough_item_quality, greater, (deliver_quality, Value, available_quality_item)) :- action(Agent, deliver_quality, Value).

% from agent, sent at time, item, number
executable(Agent, receive, Value, can_receive) :- action(Agent, receive, Value).
satisfy_condition(Agent, can_receive, has, (receive, Value, (received, delivered, FromAgent, Item))) :- recv_item(Agent, FromAgent, Item), action(Agent, receive, Value).
% from agent, sent at time, item, quality, number
executable(Agent, receive_quality, Value, can_receive_quality) :- action(Agent, receive_quality, Value).
satisfy_condition(Agent, can_receive_quality, has, (receive_quality, Value, (received_quality, delivered_quality, FromAgent, Item, Quality))) :- recv_item(Agent, FromAgent, Item, Quality), action(Agent, receive_quality, Value).
% cannot receive money if there is no notification
% from agent, sent at time, reason, amount
executable(Agent, receive_money, Value, can_receive_money) :- action(Agent, receive_money, Value).
satisfy_condition(Agent, can_receive_money, has, (receive_money, Value, (received_payment, sent_payment, FromAgent, Reason))) :- receiving_reason(Agent, FromAgent, Reason), action(Agent, receive_money, Value).
%
inertial(Agent, total_received, not_changed_last, ()) :- recv_item(Agent, FromAgent, Item).
inertial(Agent, total_received_quality, not_changed_last, ()) :- recv_item(Agent, FromAgent, Item, Quality).
inertial(Agent, total_delivered, not_changed_last, ()) :- deliver_item(Agent, ToAgent, Item).
inertial(Agent, total_delivered_quality, not_changed_last, ()) :- deliver_item(Agent, ToAgent, Item, Quality).
inertial(Agent, total_produced, not_changed_last, ()) :- produce_item(Agent, Item).
inertial(Agent, total_produced_quality, not_changed_last, ()) :- produce_item(Agent, Item, Quality).
inertial(Agent, available_item, not_changed_last, ()) :- item(Agent, Item).
inertial(Agent, available_quality_item, not_changed_last, ()) :- item(Agent, Item, Quality).
inertial(Agent, total_sent_payment, not_changed_last, ()) :- paying_reason(Agent, ToAgent, Reason).
inertial(Agent, total_received_payment, not_changed_last, ()) :- receiving_reason(Agent, FromAgent, Reason) .
%
inertial(Agent, received, always_inertial, ()) :- recv_item(Agent, FromAgent, Item).
inertial(Agent, sent_payment, always_inertial, ()) :- pay_item(Agent, ToAgent, Item).
inertial(Agent, received_quality, always_inertial, ()) :- recv_item(Agent, FromAgent, Item, Quality).
inertial(Agent, delivered, always_inertial, ()) :- deliver_item(Agent, ToAgent, Item).
inertial(Agent, delivered_quality, always_inertial, ()) :- deliver_item(Agent, ToAgent, Item, Quality).