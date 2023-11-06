% ------ Input Interface ------
% get property
property(P) :- input(P,"rdf:type","cpsf:Property").
% get description
descr(P,D) :- input(P,"rdfs:comment",D).
% get atomic statement
atomic_statement(P,A) :- input(P,"cpsf:atomicStatement",A).
% get assertion
isAssertion(P) :- input(P,"cpsf:hasType","cpsf:PropertyType_Assertion").
% get concern
concern(C) :- input(C,"rdf:type","cpsf:Concern").
% get aspect
aspect(A) :- input(A,"rdf:type","cpsf:Aspect").
% subsconcern
subconcern(S,O) :- input(S,"cpsf:includesConcern",O).

% every aspect is a concern
concern(A) :- aspect(A).

% meta-aspect "all", which is a parent of every aspect
concern(all).
subconcern(all,A) :-
	aspect(A).

% functional composition 
nextFC(F1,F2) :- input(F2,"cpsf:nextFC",F1).

% Auxiliary relation isFunctionClass
% is function
isFunctionClass(F1) :- nextFC(F1,F2).
isFunctionClass(F2) :- nextFC(F1,F2).
% function class of hte function
functionClass(F,FC) :- isFunctionClass(FC), input(F,"rdf:type",FC).
% refined into
refinedInto(F1,F2) :- input(F1,"cpsf:refinedInto",F2).
% has  
hasBC(APP,BC) :- input(APP,"cpsf:hasBC",BC).
% a concern relevant to a function
relevantToFunc(C,F) :- input(C,"cpsf:relevantToFunc",F).

% a concern is relevant to F if a sub-concern is relevant to F  
relevantToFunc(C1,F) :- relevantToFunc(C2,F), subconcern(C1,C2).
-isAssertion(P) :- property(P), not isAssertion(P).

% get rule 
rule(R) :- input(R,"cpsf:addressesConcern",C).
% rule addresses by function 
addressesAtFunc(R,F) :- input(R,"cpsf:addressesAtFunc",F).
% rule addresses concern
addressesConcern(R,C) :- input(R,"cpsf:addressesConcern",C).
% property address polarity concern
addressesPolarity(R,P) :- input(R,"cpsf:addressesPolarity",PO), asp_polarity(PO,P).

% concern has condition 
hasCondition(R,C) :- input(R,"cpsf:hasCondition",C).
% condition property of a concern
conditionProperty(C,A) :- input(C,"cpsf:conditionProperty",P), atomic_statement(P,A).
% condition polarity 
conditionPolarity(C,P) :- input(C,"cpsf:conditionPolarity",PO), asp_polarity(PO,P).
asp_polarity("cpsf:positive",pos).
asp_polarity("cpsf:negative",neg).

% ------ Theory ------

% transitive closure of subconcern/2
tc(subconcern(C1,C2)) :- subconcern(C1,C2).
tc(subconcern(C1,C2)) :- subconcern(C1,C3), tc(subconcern(C3,C2)).

% transitive closure of subconcern/2, reflexive variant
tc0(subconcern(C,C)) :- concern(C).
tc0(subconcern(C1,C2)) :- tc(subconcern(C1,C2)).


% ---------------> Impact of requirements on concerns <---------------
% ASSUMPTION: satisfaction of concerns does not affect satisfaction of properties
addresses(Q,C,F) :-
	rule(Rule),
	addressesAtFunc(Rule,F),
	addressesConcern(Rule,C),
	hasCondition(Rule,Cond),
	conditionProperty(Cond,Q).


hold(impacted(C,F,M),S) :-
	step(S),
	rule(Rule),
	addressesAtFunc(Rule,F),
	addressesConcern(Rule,C),
	addressesPolarity(Rule,M),
	body_satisfied(Rule,S).

body_satisfied(Rule,S) :-
	step(S),
	rule(Rule),
	not -body_satisfied(Rule,S).

-body_satisfied(Rule,S) :-
	step(S),
	rule(Rule),
	hasCondition(Rule,Cond),
% ASSUMPTION: satisfaction of concerns does not affect satisfaction of properties
	-condSat(Cond,S).

% ASSUMPTION: satisfaction of concerns does not affect satisfaction of properties
-condSat(Cond,S) :-
	step(S),
	hasCondition(Rule,Cond),
	conditionProperty(Cond,A),
	conditionPolarity(Cond,pos),
	not hold(sat(A),S).

% ASSUMPTION: satisfaction of concerns does not affect satisfaction of properties
-condSat(A,S) :-
	step(S),
	hasCondition(Rule,Cond),
	conditionProperty(Cond,A),
	conditionPolarity(Cond,neg),
	not -hold(sat(A),S).


% DEBUGGING
%condSat(Cond,S) :-
%	step(S),
%	hasCondition(Rule,Cond),
%	conditionProperty(Cond,A),
%	conditionPolarity(Cond,pos),
%	not -hold(sat(A),S).
%condSat(A,S) :-
%	step(S),
%	hasCondition(Rule,Cond),
%	conditionProperty(Cond,A),
%	conditionPolarity(Cond,neg),
%	not hold(sat(A),S).


% The satisfaction of requirements is handled explicitly
% by user-provided state constraints
%-hold(sat_property(A),S) :-
%	step(S),
%	atomic_statement(P,A),
%	isAssertion(P),
%	not hold(A,S).
%
%-hold(sat(C),S) :-
%	step(S),
%	addresses(C,P),
%	atomic_statement(P,A), 
%	-hold(sat_property(A),S).

fluent(sat(A)) :- atomic_statement(P,A).
fluent(sat(A)) :- config_feature(A).
fluent(sat(C,F)) :- relevantToFunc(C,F).
impact_mode(pos). impact_mode(neg).
fluent(impacted(C,F,M)) :- concern(C), isFunctionClass(F), impact_mode(M).


% sat_sub(C,F) holds iff every relevant sub-concern of C is satisfied
%-hold(sat_sub(C1,F),S) :-
%	step(S), relevantToFunc(C1,F),
%	subconcern(C1,C2), relevantToFunc(C2,F),
%	not hold(sat(C2,F),S).
%fluent(sat_sub(C,F)) :- relevantToFunc(C,F).
%defined(neg,sat_sub(C,F)) :- relevantToFunc(C,F).

% The satisfaction of C in F is impacted by some combination of requirements at S
impacted(C,F,S) :-
	step(S), relevantToFunc(C,F),impact_mode(M),
	hold(impacted(C,F,M),S).

% Concern C has at least one relevant sub-concern in function F
has_relevant_subconcern(C1,F) :-
	subconcern(C1,C2), relevantToFunc(C2,F).

% A concern is positively influenced if:
% 1. a combination of requirements impacts it positively OR
% 2. a relevant sub-concern is satisfied
positively_influenced(C,F,S) :-
	step(S), relevantToFunc(C,F),
	hold(impacted(C,F,pos),S).
positively_influenced(C1,F,S) :-
	step(S), relevantToFunc(C1,F),
%	has_relevant_subconcern(C1,F),
%	hold(sat_sub(C1,F),S).
	subconcern(C1,C2), relevantToFunc(C2,F),
	hold(sat(C2,F),S).

% A concern is negatively influenced if:
% 1. a combination of requirements impacts it negatively OR
% 2. a relevant sub-concern is unsatisfied
negatively_influenced(C,F,S) :-
	step(S), relevantToFunc(C,F),
	hold(impacted(C,F,neg),S).
negatively_influenced(C1,F,S) :-
	step(S), relevantToFunc(C1,F),
%	has_relevant_subconcern(C1,F),
%	-hold(sat_sub(C1,F),S).
	subconcern(C1,C2), relevantToFunc(C2,F),
	-hold(sat(C2,F),S).

% A concern is affected by uncertain influence (from its sub-concerns) if:
% 1. a relevant sub-concern has unknown satisfaction
uncertainly_influenced(C1,F,S) :-
	step(S), relevantToFunc(C1,F),
%	has_relevant_subconcern(C1,F),
%	not hold(sat_sub(C1,F),S),
%	not -hold(sat_sub(C1,F),S).
	subconcern(C1,C2), relevantToFunc(C2,F),
	not hold(sat(C2,F),S),
	not -hold(sat(C2,F),S).


%%%%%%%% INFERENCE ON CONCERN SATISFACTION
%
% Select the type of inference with:
%
%   inference(concerns,pessimistic)
%   inference(concerns,skeptical)
%   inference(concerns,optimistic)
%

% PESSIMISTIC INFERENCE ON CONCERN SATISFACTION
% This is the simplest case, where concerns default to unsatisfied
% 
% A concern (in a given function f, e.g. use case u1) is satisfied if:
%   1. it is positively influenced AND
%   2. it is not negatively influenced
hold(sat(C,F),S) :-
	inference(concerns,pessimistic),
	step(S), relevantToFunc(C,F),
	positively_influenced(C,F,S),
	not negatively_influenced(C,F,S).

likelihood(sat(C,F),S,L) :-
	inference(concerns,pessimistic),
	step(S), relevantToFunc(C,F),
	positively_influenced(C,F,S),
	not negatively_influenced(C,F,S),
	likelihood_sat(C,F,S,L).
	%degree_impacted_pos(C,F,S,L).

% A concern is unsatisfied in all other cases.
defined(pos,sat(C,F)) :- inference(concerns,pessimistic), relevantToFunc(C,F). 

% SKEPTICAL INFERENCE ON CONCERN SATISFACTION
% This is a more advanced case, where the satisfaction status of a
% concern may remain unknown/undecided/uncertain
% 
% A concern (in a given function f, e.g. use case u1) is satisfied if:
%   1. it is positively influenced AND
%   2. it is not negatively influenced AND
%   3. is not affected by uncertain influence
hold(sat(C,F),S) :-
	inference(concerns,skeptical),
	step(S), relevantToFunc(C,F),
	positively_influenced(C,F,S),
	not negatively_influenced(C,F,S),
	not uncertainly_influenced(C,F,S).

likelihood(sat(C,F),S,D) :-
	inference(concerns,skeptical),
	step(S), relevantToFunc(C,F),
	positively_influenced(C,F,S),
	not negatively_influenced(C,F,S),
	not uncertainly_influenced(C,F,S),
	likelihood_sat(C,F,S,D).
	%degree_impacted_pos(C,F,S,D).

% A concern is unsatisfied if:
%   1. it is negatively influenced AND
%   2. it is not positively influenced AND
%   3. is not affected by uncertain influence
-hold(sat(C,F),S) :-
	inference(concerns,skeptical),
	step(S), relevantToFunc(C,F),
	negatively_influenced(C,F,S),
	not positively_influenced(C,F,S),
	not uncertainly_influenced(C,F,S).
% OR
%   1. it has no relevant sub-concerns AND
%   2. it is not positively influenced AND
%   3. it is not negatively influenced
-hold(sat(C,F),S) :-
	inference(concerns,skeptical),
	step(S), relevantToFunc(C,F),
	not has_relevant_subconcern(C,F),
	not positively_influenced(C,F,S),
	not negatively_influenced(C,F,S).


% The satisfaction status of a concern is unknown in all other cases.
% Implemented by making sat(C,F) inertial rather than defined


% OPTIMISTIC INFERENCE ON CONCERN SATISFACTION
% This is another simple case, where concerns default to unsatisfied,
% but concerns that have no requirements nor sub-concerns are vacuously
% satisfied.
% 
% A concern (in a given function f, e.g. use case u1) is satisfied if:
%   1. it is positively influenced AND
%   2. it is not negatively influenced
hold(sat(C,F),S) :-
	inference(concerns,optimistic),
	step(S), relevantToFunc(C,F),
	positively_influenced(C,F,S),
	not negatively_influenced(C,F,S).
likelihood(sat(C,F),S,D) :-
	inference(concerns,optimistic),
	step(S), relevantToFunc(C,F),
	positively_influenced(C,F,S),
	not negatively_influenced(C,F,S),
	likelihood_sat(C,F,S,D).
	%degree_impacted_pos(C,F,S,D).
% OR
%   1. it has no relevant sub-concerns AND
%   2. it is not positively influenced AND
%   3. it is not negatively influenced
hold(sat(C,F),S) :-
	inference(concerns,optimistic),
	step(S), relevantToFunc(C,F),
	not has_relevant_subconcern(C,F),
	not positively_influenced(C,F,S),
	not negatively_influenced(C,F,S).
likelihood(sat(C,F),S,D) :-
	inference(concerns,optimistic),
	step(S), relevantToFunc(C,F),
	not has_relevant_subconcern(C,F),
	not positively_influenced(C,F,S),
	not negatively_influenced(C,F,S),
	likelihood_sat(C,F,S,D).
	%degree_impacted_pos(C,F,S,D).

% A concern is unsatisfied in all other cases.
defined(pos,sat(C,F)) :- inference(concerns,optimistic), relevantToFunc(C,F). 


%%%% Relatedness of requirements across functions

% Definition. Requirement q1 is refined into requirement q2
% if they address the same concern in two functions F1 and F2
% and F1 is refined into F2.
refinedInto(Q1,Q2) :-
	addresses(Q1,C,F1),
	addresses(Q2,C,F2),
	refinedInto(F1,F2).

% Definition. Requirement q1 is related to requirement q2
% if there is a sequence r_1,...,r_k of requirements such that 
% q1 =r_1, q2=r_k, and every r_i is refined into r_i+1.
related(Q1,Q2) :-
	refinedInto(Q1,Q2),
	addresses(Q1,C,F1),	% make sure Q1, Q2 are requirements
	addresses(Q2,C,F2). % rather than functions

related(Q1,Q3) :-
	refinedInto(Q1,Q2),
	related(Q2,Q3).


%%%%%%%% OBSERVATIONS


% initial state of the CPS

hold(F,0) :-
	fluent(F),
	obs(F,true).

-hold(F,0) :-
	fluent(F),
	obs(F,false).

hold(F,0) :-
	fluent(F),
	assumed(F,true),
	not -hold(F,0).

-hold(F,0) :-
	fluent(F),
	assumed(F,false),
	not hold(F,0).

% Ad-hoc for prob_of_state functional fluent
hold(prob_of_state(100),0).

% next state: inertia axioms
is_defined(F) :- fluent(F), defined(M,F).

% NOTE: inertial for numerical fluents is defined on a case-by-case basis
-inertial(F) :- is_numerical(F).
-inertial(F) :- is_defined(F).

hold(F,S2) :-
	fluent(F),
	not -inertial(F),
	step(S), step(S2), S2=S+1,
	hold(F,S),
	not -hold(F,S2).

-hold(F,S2) :-
	fluent(F),
	not -inertial(F),
	step(S), step(S2), S2=S+1,
	-hold(F,S),
	not hold(F,S2).

hold(F,S) :-
	fluent(F),
	defined(neg,F),
	step(S),
	not -hold(F,S).

-hold(F,S) :-
	fluent(F),
	defined(pos,F),
	step(S),
	not hold(F,S).

% effect of a negative impact
-hold(A,S) :-
	impacted(neg,A,S).


% Ad-hoc treatment of prob_of_state functional fluent
hold(prob_of_state(P2),S2) :-
	step(S), step(S2), S2=S+1,
	hold(prob_of_state(P),S),
	do(A,S),
	prob_success(A,PSucc),
	P2a=P*PSucc,
	P2=P2a/100.

-unk_prob_success(S) :-
	step(S),
	do(A,S), prob_success(A,PSucc).
unk_prob_success(S) :-
	step(S),
	not -unk_prob_success(S).

hold(prob_of_state(P),S2) :-
	step(S), step(S2), S2=S+1,
	hold(prob_of_state(P),S),
	unk_prob_success(S).
%       -- to be used together with theory*.lp
%          and with step1-BASE.lp

% Reason optimistically about concerns, concerns default to unsatisfied,
% but concerns that have no requirements nor sub-concerns are vacuously
% satisfied.
%
% The example shows that, under this reasoning mode, the entire concern
% tree is satisfied.

% Enable optimistic inference on concern satisfaction
inference(concerns,optimistic).