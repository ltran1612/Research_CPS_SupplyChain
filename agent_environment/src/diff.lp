time(11).
diff1(hold(A), T) :- hold(A, T), not hold_plan(A, T), time(T).
diff1(occur(A), T) :- occur(A, T), not occur_plan(A, T), time(T).
diff2(hold(A), T) :- not hold(A, T), hold_plan(A, T), time(T).
diff2(occur(A), T) :- not occur(A, T), occur_plan(A, T), time(T).

#show diff1/2.
#show diff2/2.
