% % Base initial state for the product/deliver/receive domain for agents in supply chain
hold(total_sent_payment, (Agent, (ToAgent, Reason, 0)), 0) :- paying_reason(Agent, ToAgent, Reason).
hold(total_received_payment, (Agent, (FromAgent, Reason, 0)), 0) :- receiving_reason(Agent, FromAgent, Reason).
% %
hold(available_funds, (Agent, (122222,)), 0) :- payment_reason(Agent, _, _). 
% %
hold(total_produced_quality, (Agent, (Item, Quality, 0)), 0) :- produce_item(Agent, Item, Quality). 
hold(total_produced, (Agent, (Item, 0)), 0) :- produce_item(Agent, Item). 
% %
hold(total_delivered_quality, (Agent, (ToAgent, Item, Quality, 0)), 0) :- deliver_item(Agent, ToAgent, Item, Quality).
hold(total_delivered, (Agent, (ToAgent, Item, 0)), 0) :- deliver_item(Agent, ToAgent, Item).
% %
hold(total_received, (Agent, (FromAgent, Item, Quality, 0)), 0) :- recv_item(Agent, FromAgent, Item, Quality).
hold(total_received, (Agent, (FromAgent, Item, 0)), 0) :- recv_item(Agent, FromAgent, Item).
% %
hold(available_item, (Agent, (Item, 0)), 0) :- item(Agent, Item).
hold(available_quality_item, (Agent, (Item, Quality, 0)), 0) :- item(Agent, Item, Quality).