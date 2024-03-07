hold(payment(Agent, Reason, 0), 0) :- payment_reason(Agent, Reason).
hold(available_funds(0), 0). 
hold(produced(Item, 0, Quality), 0) :- produce_item(Item, Quality). 
hold(produced(Item, 0), 0) :- produce_item(Item). 
hold(delivered(Agent, Item, 0, Quality), 0) :- deliver_item(Agent, Item, Quality).
hold(delivered(Agent, Item, 0), 0) :- deliver_item(Agent, Item).
hold(available_item(Item, 0), 0) :- item(Item).
hold(available_item(Item, 0, Quality), 0) :- item(Item, Quality).