% needs to supply the following
% taken from BASE/theory in the original thanhnh reasearch repository
property(P) :- input(P,"rdf:type","cpsf:Property").
concern(C) :- input(C,"rdf:type","cpsf:Concern").
subconcern(S,O) :- input(S,"cpsf:includesConcern",O).
% made up based on the observation in the ontology (NEEDS VERIFICATION) 
% input("cpsf:g7","rdf:type","cpsf:Formulas").
formulas(G) :- input(G, "rdf:type", "cpsf:Formulas").
% based on input("cpsf:Energy_Func","cpsf:decomposition_function_of","cpsf:Integrity").
func_dec(F,C) :- input(F,"cpsf:decomposition_function_of",C).
%
% input("cpsf:IRIS_Scan","cpsf:addConcern","cpsf:Authorization").
addressedBy(C,P) :- input(P,"cpsf:addConcern",C), property(P), concern(C).
% input("cpsf:Two_Factors","cpsf:memberOf","cpsf:g2").
member(P, G) :- input(P,"cpsf:memberOf",G), formulas(G), property(P).
% input("cpsf:g7","cpsf:addressToFunc","cpsf:Operation_Func").
addressToFunc(C,F,G) :- input(G,"cpsf:addressToFunc",F), func_dec(F, C), formulas(G), concern(C).

% taken from thanhnh CPSOntology repository sophiticated reasoning
%---- Reasoning Concern Satisfaction by Formulae of properties ----- modified, this formula is disjunction
sat_formulas(C,F,G,T) :- concern(C), property(P), formulas(G), 
                          func_dec(F,C), addressedBy(C,P), member(P,G), addressToFunc(C,F,G),
                          h(sat(P),T), step(T).
-sat_formulas(C,F,G,T) :- concern(C), formulas(G), func_dec(F,C), addressToFunc(C,F,G),
                         not sat_formulas(C,F,G,T), step(T).
-h(sat(C,F),T) :- concern(C), func_dec(F,C), step(T), not sat_formulas(C,F,_,T).
h(sat(C,F),T)  :- not -h(sat(C,F),T), step(T), func_dec(F,C).
-h(sat(C),T)   :- concern(C), func_dec(F,C), not h(sat(C,F),T), step(T).
-h(sat(C),T)   :- concern(C), func_dec(F,C), -h(sat(C,F),T), step(T).

%---- Traditiona Reasoning about Concern Satisfaction ---                       
-h(sat(C),T) :- -h(sat(P),T), property(P), step(T), addressedBy(C,P), not member(P,_).
-h(sat(X),T) :- concern(X), concern(Y), subconcern(X,Y), not h(sat(Y),T), step(T).
-h(sat(X),T) :- concern(X), concern(Y), subconcern(X,Y), -h(sat(Y),T), step(T).
h(sat(C),T) :- not -h(sat(C),T), concern(C), step(T).

% interface from ontolo to the simulator
h(A, T) :- hold(A, T).
step(T) :- time(T).
%
h(sat(P),T) :- h(sat(Cl),T), clause(Cl), step(T), addressedBy(P,Cl), property(P). 
-h(sat(P),T) :- not h(sat(Cl),T), clause(Cl), step(T), addressedBy(P,Cl), property(P). 
%
:- clause(Cl), addressedBy(P,Cl), not property(P).
