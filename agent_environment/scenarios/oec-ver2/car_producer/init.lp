hold(payment(Reason, 0), 0) :- reason(Reason).
hold(available_fund(0), 0). 
hold(available_item(Item, 0), 0) :- item(Item).