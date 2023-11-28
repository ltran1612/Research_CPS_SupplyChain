% ------ Input Interface ------
property(P) :- input(P,"rdf:type","cpsf:Property").
concern(C) :- input(C,"rdf:type","cpsf:Concern").
aspect(A) :- input(A,"rdf:type","cpsf:Aspect").
subConcern(S,O) :- input(S,"cpsf:includesConcern",O).
addressedBy(C, P) :- input(P, "cpsf:addressesConcern", C).

% every aspect is a concern
concern(A) :- aspect(A).

h(sat(Property), Time) :- property(Property), clause(Clause), addressedBy(Property, Clause), h(sat(Clause), Time).
h(sat(Concern), Time) :- concern(Concern), property(Property), addressedBy(Concern, Property), h(sat(Property), Time).
h(sat(Concern), Time) :- concern(Concern), concern(SubConcern), subConcern(Concern, SubConcern), h(sat(SubConcern), Time).