% To reduce the output, manually ground the following rule for concerns C that you are interested in

%% relevantToFunc(C,"cpsf:bc1") :- concern(C).

relevantToFunc("cpsf:Cost","cpsf:bc1")                  :- concern("cpsf:Cost").
relevantToFunc("cpsf:TimeToMarket","cpsf:bc1")   :- concern("cpsf:TimeToMarket").
relevantToFunc("cpsf:Policy","cpsf:bc1")                :- concern("cpsf:Policy").
relevantToFunc("cpsf:Performance","cpsf:bc1")     :- concern("cpsf:Performance").
relevantToFunc("cpsf:Reliability","cpsf:bc1")          :- concern("cpsf:Reliability").
relevantToFunc("cpsf:Safety","cpsf:bc1")               :- concern("cpsf:Safety").

% Quick workaround since I forgot to include descriptions for the new properties
descr(P,P) :- atomic_statement(P,A), not input(P,"rdfs:comment",_).

% The pair <Clause_ID, A> is in the private part of the contract. A is a property/requirement
private_part(C,A) :- input(C,"cpsf:addProperty",P), atomic_statement(P,A).

hold(impacted(C,"cpsf:bc1",pos),S) :-
	step(S),
	private_part(_,A),
	hold(sat(A),S),
	atomic_statement(P,A),
	input(P,"cpsf:addConcern",C).

hold(impacted(C,"cpsf:bc1",neg),S) :-
	step(S),
	private_part(_,A),
	-hold(sat(A),S),
	atomic_statement(P,A),
	input(P,"cpsf:addConcern",C).

