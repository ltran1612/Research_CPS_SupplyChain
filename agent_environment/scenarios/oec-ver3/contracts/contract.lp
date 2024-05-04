satisfies(C, T) :- step(T), clause(C, _, F, by(N)), T<=N, holds(F, T).
not_satisfies(C, T) :- step(T), clause(C, _, F, by(N)), T<=N, not holds(F, T).
satisfies(C, T) :- step(T), clause(C, _, F, by(M,N)), M<=T, T<=N, holds(F, T).
not_satisfies(C, T) :- step(T), clause(C, _, F, by(M,N)), M<=T, T<=N, not holds(F, T).