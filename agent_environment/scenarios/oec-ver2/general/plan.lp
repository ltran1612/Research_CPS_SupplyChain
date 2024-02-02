0 {occur(pay(Reason, Amount), T) :number(Amount), reason(Reason) } 1 :- time(T). 
0 {occur(receive_money(Reason, Amount), T) :number(Amount), reason(Reason) } 1 :- time(T).
0 {occur(receive(Item, Amount), T) :item(Item), number(Amount) } 1 :- time(T).
0 {occur(receive(Item, Amount, Quality), T) :item(Item), number(Amount), quality(Quality) } 1 :- time(T).
0 {occur(produce(Item, Amount), T) :produce_item(Item), number(Amount) } 1 :- time(T).
0 {occur(produce(Item, Amount, Quality), T) :produce_item(Item), number(Amount), quality(Quality) } 1 :- time(T).
0 {occur(deliver(Item, Amount), T) :deliver_item(Item), number(Amount) } 1 :- time(T).
0 {occur(deliver(Item, Amount, Quality), T) :deliver_item(Item), number(Amount), quality(Quality) } 1 :- time(T).