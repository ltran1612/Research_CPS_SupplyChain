% initial states of fluents
hold(board(0, X), 0) :- quality(X).
hold(total_delivered(0, X), 0) :- quality(X).
hold(received(0), 0).

% actions did 
occur(produce(100, 1), 0).
occur(deliver(50, 1), 1).
occur(deliver(50, 1), 4).

% observation
observe(payment(100), 2).