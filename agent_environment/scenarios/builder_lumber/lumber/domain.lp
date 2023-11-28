% lumber
% actions: produce, deliver, buy, loan, and receive 
% fluents: board, abnormal, received, total_delivered
% conditions: we can only deliver if there is enough board. 

:-  occur(deliver(Quantity, Quality), Time), 
    h(board(Available, Quality), Time), not Available>=Quantity,
    step(Time) 
    .

% board
% produce
% excutability laws
:- X=produce(Quantity, Quality), occur(X, Time), h(abnormal(X), Time).
% dynamic laws 
h(board(NewAvailable, Quality), Time+1) :- NewAvailable=Quantity+Available, 
    occur(produce(Quantity, Quality), Time), 
    not occur(deliver(_, Quality), Time), 
    h(board(Available, Quality), Time),
    step(Time), step(Time+1)
    . 

% deliver
% causation of delivery
h(board(NewAvailable, Quality), Time+1) :- NewAvailable=Available-Quantity, 
    occur(deliver(Quantity, Quality), Time), 
    not occur(produce(_, Quality), Time), 
    h(board(Available, Quality), Time),
    step(Time), step(Time+1)
    . 

% causation of both delivery and produce in the same step
h(board(NewAvailable, Quality), Time+1) :- NewAvailable=Available-Quantity1+Quantity2, 
    occur(deliver(Quantity1, Quality), Time), 
    occur(produce(Quantity2, Quality), Time), 
    h(board(Available, Quality), Time),
    step(Time), step(Time+1)
    . 

% total_produced
% causation of produce
h(total_produced(NewAmount, Quality), Time + 1) :- NewAmount = Quantity + OldAmount,
    occur(produce(Quantity, Quality), Time), 
    h(total_produced(OldAmount, Quality), Time),
    step(Time), step(Time+1)
    .

% total_delivered
% dynamic laws 
h(total_delivered(NewDelivered, Quality), Time+1) :- NewDelivered=Quantity+Delivered, 
    occur(deliver(Quantity, Quality), Time), 
    h(total_delivered(Delivered, Quality), Time),
    step(Time), step(Time+1)
    . 

% delivered
% dynamic laws
h(delivered(Quantity, Quality), Time+1) :- occur(deliver(Quantity, Quality), Time),
    step(Time), step(Time+1)
    . 

% received 
% dynamic laws
h(received(NewAmount), Time+1) :-  NewAmount=Amount+Current, 
    h(received(Current), Time), 
    observe(payment(Amount), Time),
    step(Time), step(Time+1)
    .

% inertial rules
% board
h(board(Quantity, Quality), Time + 1) :- step(Time+1), step(Time), 
    h(board(Quantity, Quality), Time), 
    0=#count{X1: occur(produce(X1, Quality), Time)}, 
    0=#count{X2: occur(deliver(X2, Quality), Time)}
    .

% total produced
h(total_produced(Quantity, Quality), Time + 1) :- step(Time+1), step(Time), 
    h(total_produced(Quantity, Quality), Time), 
    0=#count{X1: occur(produce(X1, Quality), Time)} 
    .

% total delivered
h(total_delivered(Quantity, Quality), Time + 1) :- step(Time+1), step(Time),
    h(total_delivered(Quantity, Quality), Time),
    0=#count{X2: occur(deliver(X2, Quality), Time)}
    .

%received
h(received(Amount), Time+1) :- step(Time), step(Time+1),
    h(received(Amount), Time),
    0=#count{X: observe(payment(X), Time)}
    .

% other objects
% equipment(cutters).
% other actions
% receive
% buy
% loan