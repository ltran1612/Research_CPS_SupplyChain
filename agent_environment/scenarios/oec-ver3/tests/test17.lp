% test traditional cps ontology reasoning
% expect satisfaction
h(sat("cpsf:received_on_schedule"), 0).
% obs(sat("cpsf:received_on_schedule"),true).
:- not h(sat("cpsf:Functionality"), 0).
:- h(sat(A), T), subconcern(A, B), not h(sat(B), T).
:- h(sat(A), T), addressedBy(B, A), not h(sat(B), T).
time(0).
