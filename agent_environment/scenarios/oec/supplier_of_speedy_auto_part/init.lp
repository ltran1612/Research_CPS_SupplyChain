hold(tool_part(0, Q), 0) :- quality(Q).
hold(money(100000), 0).
hold(payment(tool_parts, 0), 0).
hold(delivered(tool_parts, 0, Q), 0) :- quality(Q).