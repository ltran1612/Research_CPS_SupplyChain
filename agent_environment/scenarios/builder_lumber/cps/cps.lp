% ------ Input Interface ------
property(P) :- input(P,"rdf:type","cpsf:Property").
concern(C) :- input(C,"rdf:type","cpsf:Concern").
aspect(A) :- input(A,"rdf:type","cpsf:Aspect").
subConcern(S,O) :- input(S,"cpsf:includesConcern",O).
addressedBy(C, P) :- input(P, "cpsf:addressesConcern", C).

% every aspect is a concern
concern(A) :- aspect(A).

hold(sat(Property), Time) :- property(Property), clause(Clause), addressedBy(Property, Clause), hold(sat(Clause), Time).
hold(sat(Concern), Time) :- concern(Concern), property(Property), addressedBy(Concern, Property), hold(sat(Property), Time).
hold(sat(Concern), Time) :- concern(Concern), concern(SubConcern), subConcern(Concern, SubConcern), hold(sat(SubConcern), Time).