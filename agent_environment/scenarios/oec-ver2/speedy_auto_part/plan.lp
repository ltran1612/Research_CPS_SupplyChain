% base plan script for oec scenario. 

0 {occur(pay(Reason, Amount), T) :number(Amount), reason(Reason) } 1 :- time(T). 
0 {occur(receive_money(Reason, Amount), T) :number(Amount), reason(Reason) } 1 :- time(T).
0 {occur(receive((Agent, TimeMark), Item, Amount), T) 
    : number(Amount), hold(notification((Agent, TimeMark), Item), T)
} 1 :- time(T). 
0 {occur(receive((Agent, TimeMark), Item, Amount, Quality), T) 
    : hold(notification((Agent, TimeMark), Item), T), number(Amount), quality(Quality) 
} 1 :- time(T).
0 {occur(produce(Item, Amount), T) :produce_item(Item), number(Amount) } 1 :- time(T).
0 {occur(produce(Item, Amount, Quality), T) :produce_item(Item), number(Amount), quality(Quality) } 1 :- time(T).
0 {occur(deliver(Item, Amount), T) :deliver_item(Item), number(Amount) } 1 :- time(T).
0 {occur(deliver(Item, Amount, Quality), T) :deliver_item(Item), number(Amount), quality(Quality) } 1 :- time(T).

time(0..lastTimeStep).
satisfied_clauses_count(N) :- N = #count{Clause : hold(sat(Clause), lastTimeStep), clause(Clause)}.
#maximize {N : satisfied_clauses_count(N)}. 