% initialization
h(available_board(0, X), 0) :- quality(X).
h(available_funds(1000000), 0).
h(total_payment(0, board), 0).

% receive wood
% observe(delivered(100, 1), 0).
% occur(receive(100, 1), 0).

% make payment
% occur(pay(1000, board), 2).
% occur(pay(143000, board), 3).

% output
% #show satisfied_concern/1.
% #show satisfied_property/1.
% #show satisfied_clause/1.

% #show h/2.
% #show property/1.
% #show addressedBy/2.