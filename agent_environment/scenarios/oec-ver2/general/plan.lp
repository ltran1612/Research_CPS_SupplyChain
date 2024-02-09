% base plan script for oec scenario. 

% planning to pay the item we want to pay for and potentially the delivery fee (if any)
0 {occur(pay(Item, Amount), T) :number(Amount), pay_item(Item) } 1 :- time(T). 
0 {occur(pay(delivery(Item), Amount), T) :number(Amount), pay_item(Item) } 1 :- time(T). 
% planning to receive money when we have notifications
0 {occur(receive_money(Reason, Amount), T) :number(Amount), reason(Reason) } 1 :- time(T).
% planning to receive items that we want to receive when we have notification. 
0 {occur(receive((Agent, TimeMark), Item, Amount), T) 
    : number(Amount), hold(notification((Agent, TimeMark), Item), T)
} 1 :- time(T). 
0 {occur(receive((Agent, TimeMark), Item, Amount, Quality), T) 
    : hold(notification((Agent, TimeMark), Item), T), number(Amount), quality(Quality) 
} 1 :- time(T).
% planning to produce items
0 {occur(produce(Item, Amount), T) :produce_item(Item), number(Amount) } 1 :- time(T).
0 {occur(produce(Item, Amount, Quality), T) :produce_item(Item), number(Amount), quality(Quality) } 1 :- time(T).
% planning to deliver items
0 {occur(deliver(Item, Amount), T) :deliver_item(Item), number(Amount) } 1 :- time(T).
0 {occur(deliver(Item, Amount, Quality), T) :deliver_item(Item), number(Amount), quality(Quality) } 1 :- time(T).