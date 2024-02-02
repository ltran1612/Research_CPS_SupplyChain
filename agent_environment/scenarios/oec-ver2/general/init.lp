hold(payment(Reason, 0), 0) :- reason(Reason).
hold(available_fund(0), 0). 
hold(produced(Item, 0, Quality), 0) :- produce_item(Item), quality(Quality). 
hold(produced(Item, 0), 0) :- produce_item(Item). 
hold(delivered(Item, 0, Quality), 0) :- deliver_item(Item), quality(Quality). 
hold(delivered(Item, 0), 0) :- deliver_item(Item).
hold(available_item(Item, 0), 0) :- item(Item).
hold(available_item(Item, 0, Quality), 0) :- item(Item), quality(Quality). 