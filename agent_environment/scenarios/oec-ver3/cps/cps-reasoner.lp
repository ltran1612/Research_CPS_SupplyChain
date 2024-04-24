% needs to supply the following
% taken from BASE/theory in the original thanhnh reasearch repository
property(P) :- input(P,"rdf:type","cpsf:Property").
concern(C) :- input(C,"rdf:type","cpsf:Concern").
subconcern(S,O) :- input(S,"cpsf:includesConcern",O).
% made up based on the observation in the ontology (NEEDS VERIFICATION) 
% input("cpsf:g7","rdf:type","cpsf:Formulas").
formula(G) :- input(G, "rdf:type", "cpsf:Formulas").
conjunction(G) :- input(G, "rdf:type", "cpsf:Conjunction").
disjunction(G) :- input(G, "rdf:type", "cpsf:Disjunction").
formula(G) :- conjunction(G). 
formula(G) :- disjunction(G).
%
% input("cpsf:IRIS_Scan","cpsf:addConcern","cpsf:Authorization").
addressedBy(C,P) :- input(P,"cpsf:addConcern",C), 1{property(P);formula(P)}, concern(C).
% input("cpsf:Two_Factors","cpsf:memberOf","cpsf:g2").
member(P, G) :- input(P,"cpsf:memberOf",G), formula(G), 1{property(P);formula(P)}.
% input("cpsf:g7","cpsf:addressToFunc","cpsf:Operation_Func").

% taken from thanhnh CPSOntology repository sophiticated reasoning
%---- Reasoning Concern Satisfaction by Formulae of properties ----- modified, this formula is disjunction
h(F,T) :- step(T), formula(F), disjunction(F), member(G,F), h(G,T).
-h(F,T):- step(T), formula(F), disjunction(F), not h(F,T).
-h(F,T):- step(T), 1{formula(G);property(G)}, formula(F), conjunction(F), member(G,F), not h(G,T).
h(F,T) :- step(T), formula(F), conjunction(F), not -h(F,T).
-h(sat(C),T) :- concern(C), addressedBy(C,F), not h(F,T), step(T).
-h(sat(X),T) :- subconcern(X,Y), not h(sat(Y),T), concern(X), concern(Y), step(T).
-h(sat(X),T) :- subconcern(X,Y), -h(sat(Y),T), concern(X), concern(Y), step(T).
h(sat(C),T) :- not -h(sat(C),T), concern(C), step(T).
% interface from ontolo to the simulator
h(A, T) :- hold(A, T).
step(T) :- time(T).
%
h(P,T) :- h(sat(Cl),T), clause(Cl), step(T), addressedBy(P,Cl), property(P). 
-h(P,T) :- not h(sat(Cl),T), clause(Cl), step(T), addressedBy(P,Cl), property(P). 
%
:- clause(Cl), addressedBy(P,Cl), not property(P).
