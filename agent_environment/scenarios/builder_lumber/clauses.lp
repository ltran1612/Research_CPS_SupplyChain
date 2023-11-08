% contract

% clauses id 
clause("C1").
clause("C2").
clause("C3").
clause("C4").

% clause condition
% C1 : L responsible_for board(144K, Q) ∧ 1 ≤ Q when by_week 4.
hold(sat("C1"), maxStepsConst) :- hold(board(Amount, Quality), 4), Amount >= 144000, Quality >= 1.

% C2 : L responsible_for delivered(144K, Q) ∧ 2 ≤ Q when by_week 4.
hold(sat("C2"), maxStepsConst) :- hold(total_delivered(Amount, Quality), 4), Amount >= 144000, Quality >= 2.

% C3 : H responsible_for payment(122K, board) when by_week 4.
hold(sat("C3"), maxStepsConst) :- hold(total_payment(Amount, board), 4), Amount >= 122000.

% C4 : H responsible_for ∃X ≤ 500K.[payment(X, shipping)] when by_week 4.
hold(sat("C4"), maxStepsConst) :- hold(total_payment(Amount, shipping), 4), Amount <= 500000.