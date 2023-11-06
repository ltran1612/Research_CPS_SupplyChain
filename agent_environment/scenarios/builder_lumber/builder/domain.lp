% builder
% fluents: availablard_board, available_funds, 
% actions: receive, pay, loan 

% executability laws
% delivery
:- occur(pay(Amount, PaymentType), Time), hold(available_funds(Available), Time), not Available >= Amount.  

% available_board
% dynamic laws
% delivery
hold(available_board(NewQuantity, Quality), Time+1) :- NewQuantity=Quantity+CurrentQuantity, 
    step(Time), step(Time+1), 
    observe(delivered(Quantity, Quality), Time), 
    occur(receive(Quantity, Quality), Time), 
    hold(available_board(CurrentQuantity, Quality), Time)
    .

% available_funds
% dynamic laws
% pay
hold(available_funds(NewAvailable), Time+1) :- NewAvailable=Available-Amount, 
    occur(pay(Amount, PaymentType), Time),
    hold(available_funds(Available), Time)
    .

% payment
% dynamic laws
hold(payment(Amount, PaymentType), Time+1) :- occur(pay(Amount, PaymentType), Time).

% total payment
hold(total_payment(Amount+PaidAmount, PaymentType), Time+1) :- occur(pay(Amount, PaymentType), Time), 
    hold(total_payment(PaidAmount, PaymentType), Time)
    .

% inertial rules
% available_board
hold(availablard_board(Quantity, Quality), Time+1) :- step(Time), step(Time+1),
    hold(availablard_board(Quantity, Quality), Time),
    0=#count{X: occur(receive(X, Quality), Time)} 
    .

% available_funds
hold(available_funds(Amount), Time+1) :- step(Time), step(Time+1),
    hold(available_funds(Amount), Time),
    0=#count{X, Y: occur(pay(X, Y), Time)}
    .

% total payment
hold(total_payment(Amount, PaymentType), Time+1) :- step(Time), step(Time+1),
    hold(total_payment(Amount, PaymentType), Time),
    0=#count{X: occur(pay(X, PaymentType), Time)}
    .