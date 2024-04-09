recv_item(car_producer, speedy_auto_parts, vehicle_parts).
pay_item(car_producer, speedy_auto_parts, vehicle_parts).
recv_item(car_producer, precision_engine, engines).
pay_item(car_producer, precision_engine, engines).
recv_item(car_producer, sonic_electronics, radios).
pay_item(car_producer, sonic_electronics, radios).
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
action(Agent, pay, (Agent, ToAgent, Reason, Amount)) :- number(Amount), paying_reason(Agent, ToAgent, Reason). 
% TODO
action(Agent, receive_money, (Agent, FromAgent, Reason, Amount)) :- hold(sent_payment, (Agent, (FromAgent, _, Reason, Amount)), _), receiving_reason(Agent, FromAgent, Reason). 
action(Agent, receive, (Agent, FromAgent, Time, Item, Amount)) :- hold(delivered, (Agent, (FromAgent, Time, Item, Amount)), _), recv_item(Agent, FromAgent, Item).
action(Agent, receive_quality, (Agent, FromAgent, Time, Item, Amount, Quality)) :- hold(delivered, (Agent, (FromAgent, _, Item, Quality, Amount)), Time), recv_item(Agent, FromAgent, Item, Quality).
%
action(Agent, produce, (Agent, Item, Amount)) :- produce_item(Agent, Item), number(Amount).
action(Agent, produce_quality, (Agent, Item, Amount, Quality)) :- produce_item(Agent, Item, Quality), number(Amount).
action(Agent, deliver, (Agent, ToAgent, Item, Amount)) :- deliver_item(Agent, ToAgent, Item), number(Amount).
action(Agent, deliver_quality, (Agent, ToAgent, Item, Amount, Quality)) :- deliver_item(Agent, ToAgent, Item, Quality), number(Amount).

% DYNAMIC LAWS
% payment
% pay money
causes(Agent, pay, Value, total_sent_payment, increase, (Agent, pay, Value, total_sent_payment)) :- action(Agent, pay, Value).
causes(Agent, pay, Value, available_funds, decrease, (Agent, pay, Value, available_funds)) :- action(Agent, pay, Value).
% receive payment 
causes(Agent, receive_money, Value, total_received_payment, increase, (Agent, receive_money, Value, total_received_payment)) :- action(Agent, receive_money, Value).
causes(Agent, receive_money, Value, available_funds, increase, (Agent, receive_money, Value, available_funds)) :- action(Agent, receive_money, Value).
% receive items
causes(Agent, receive, Value, available_item, increase, (Agent, receive, Value, available_item)) :- action(Agent, receive, Value).
causes(Agent, receive, Value, total_received, increase, (Agent, receive, Value, total_received)) :- action(Agent, receive, Value).
%
causes(Agent, receive_quality, Value, available_quality_item, increase, (Agent, receive_quality, Value, available_quality_item)) :- action(Agent, receive_quality, Value).
causes(Agent, receive_quality, Value, total_received_quality, increase, (Agent, receive_quality, Value, total_received_quality)) :- action(Agent, receive_quality, Value).
% produce
causes(Agent, produce, Value, available_item, increase, (Agent, produce, Value, available_item)) :- action(Agent, produce, Value).
causes(Agent, produce, Value, total_produced, increase, (Agent, produce, Value, total_produced)) :- action(Agent, produce, Value).
%
causes(Agent, produce_quality, Value, available_quality_item, increase, (Agent, produce_quality, Value, available_quality_item)) :- action(Agent, produce_quality, Value).
causes(Agent, produce_quality, Value, total_produced_quality, increase, (Agent, produce_quality, Value, total_produced_quality)) :- action(Agent, produce_quality, Value).
% deliver
causes(Agent, deliver, Value, available_item, decrease, (Agent, deliver, Value, available_item)) :- action(Agent, deliver, Value).
causes(Agent, deliver, Value, total_delivered, increase, (Agent, deliver, Value, total_delivered)) :- action(Agent, deliver, Value).
%
causes(Agent, deliver_quality, Value, available_quality_item, decrease, (Agent, deliver_quality, Value, available_quality_item)) :- action(Agent, deliver_quality, Value).
causes(Agent, deliver_quality, Value, total_delivered_quality, increase, (Agent, deliver_quality, Value, total_delivered_quality)) :- action(Agent, deliver_quality, Value).

% static causal laws

% executable LAWS
% conditions
% cannot pay an amount more than available
executable(Agent, pay, Value, enough_funds) :- action(Agent, pay, Value).
satisfy_condition(Agent, enough_funds, greater, (Agent, pay, Value, available_funds)) :- action(Agent, pay, Value).
% cannot deliver an amount more than available
executable(Agent, deliver, Value, enough_item) :- action(Agent, deliver, Value). 
satisfy_condition(Agent, enough_item, greater, (Agent, deliver, Value, available_item)) :- action(Agent, deliver, Value). 
%
executable(Agent, deliver_quality, Value, enough_item_quality) :- action(Agent, deliver_quality, Value).
satisfy_condition(Agent, enough_item_quality, greater, (Agent, deliver_quality, Value, available_quality_item)) :- action(Agent, deliver_quality, Value).

% from agent, sent at time, item, number
executable(Agent, receive, Value, can_receive) :- action(Agent, receive, Value).
satisfy_condition(Agent, can_receive, has, (Agent, receive, Value, delivered, FromAgent, Item)) :- recv_item(Agent, FromAgent, Item), action(Agent, receive, Value).
% from agent, sent at time, item, quality, number
executable(Agent, receive_quality, Value, can_receive_quality) :- action(Agent, receive_quality, Value).
satisfy_condition(Agent, can_receive_quality, has, (Agent, receive_quality, Value, delivered_quality, FromAgent, Item, Quality)) :- recv_item(Agent, FromAgent, Item, Quality), action(Agent, receive_quality, Value).
% cannot receive money if there is no notification
% from agent, sent at time, reason, amount
executable(Agent, receive_money, Value, can_receive_money) :- action(Agent, receive_money, Value).
satisfy_condition(Agent, can_receive_money, has, (Agent, receive_money, Value, sent_payment, FromAgent, Reason)) :- receiving_reason(Agent, FromAgent, Reason), action(Agent, receive_money, Value).
