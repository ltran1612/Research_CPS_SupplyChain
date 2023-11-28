% builder
% fluents: availablard_board, available_funds, 
% actions: receive, pay, loan 

% executability laws
% delivery
:- occur(pay(Amount, PaymentType), Time), h(available_funds(Available), Time), not Available >= Amount.  

% available_board
% dynamic laws
% delivery
h(available_board(NewQuantity, Quality), Time+1) :- NewQuantity=Quantity+CurrentQuantity, 
    step(Time), step(Time+1), 
    observe(delivered(Quantity, Quality), Time), 
    occur(receive(Quantity, Quality), Time), 
    h(available_board(CurrentQuantity, Quality), Time)
    .

% available_funds
% dynamic laws
% pay
h(available_funds(NewAvailable), Time+1) :- NewAvailable=Available-Amount, 
    occur(pay(Amount, PaymentType), Time),
    h(available_funds(Available), Time)
    .

% payment
% dynamic laws
h(payment(Amount, PaymentType), Time+1) :- occur(pay(Amount, PaymentType), Time).

% total payment
h(total_payment(Amount+PaidAmount, PaymentType), Time+1) :- occur(pay(Amount, PaymentType), Time), 
    h(total_payment(PaidAmount, PaymentType), Time)
    .

% inertial rules
% available_board
h(availablard_board(Quantity, Quality), Time+1) :- step(Time), step(Time+1),
    h(availablard_board(Quantity, Quality), Time),
    0=#count{X: occur(receive(X, Quality), Time)} 
    .

% available_funds
h(available_funds(Amount), Time+1) :- step(Time), step(Time+1),
    h(available_funds(Amount), Time),
    0=#count{X, Y: occur(pay(X, Y), Time)}
    .

% total payment
h(total_payment(Amount, PaymentType), Time+1) :- step(Time), step(Time+1),
    h(total_payment(Amount, PaymentType), Time),
    0=#count{X: occur(pay(X, PaymentType), Time)}
    .