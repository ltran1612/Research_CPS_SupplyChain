% initial states of fluents
h(board(0, X), 0) :- quality(X).
h(total_delivered(0, X), 0) :- quality(X).
h(total_produced(0, X), 0) :- quality(X).
h(received(0), 0).

% % actions did 
% occur(produce(100, 1), 0).
% occur(deliver(50, 1), 1).
% occur(deliver(50, 1), 4).

% % observation
% observe(payment(100), 2).