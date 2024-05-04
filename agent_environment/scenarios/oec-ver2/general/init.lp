% Base initial state for the product/deliver/receive domain for agents in supply chain
hold(payment(Agent, sent,  Reason, 0), 0) :- paying_reason(Agent, Reason).
hold(payment(Agent, received,  Reason, 0), 0) :- receiving_reason(Agent, Reason).
%
hold(available_funds(0), 0). 
%
hold(produced(Item, 0, Quality), 0) :- produce_item(Item, Quality). 
hold(produced(Item, 0), 0) :- produce_item(Item). 
%
hold(delivered(Agent, Item, 0, Quality), 0) :- deliver_item(Agent, Item, Quality).
hold(delivered(Agent, Item, 0), 0) :- deliver_item(Agent, Item).
%
hold(received(Agent, Item, 0, Quality), 0) :- recv_item(Agent, Item, Quality).
hold(received(Agent, Item, 0), 0) :- recv_item(Agent, Item).
%
hold(available_item(Item, 0), 0) :- item(Item).
hold(available_item(Item, 0, Quality), 0) :- item(Item, Quality).
