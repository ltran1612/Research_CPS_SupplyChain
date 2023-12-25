% 
% builder - initial state
h(available_board(0, X), 0) :- quality(X).
h(available_funds(1000000), 0).
h(total_payment(0, board), 0).

% lumber - initial state 
h(board(0, X), 0) :- quality(X).
h(total_delivered(0, X), 0) :- quality(X).
h(total_produced(0, X), 0) :- quality(X).
h(received(0, PaymentType), 0) :- paymentType(PaymentType).