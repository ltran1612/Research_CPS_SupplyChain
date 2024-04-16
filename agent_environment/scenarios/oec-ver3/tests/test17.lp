% test traditional cps ontology reasoning
% expect satisfaction
h(sat("cpsf:Received_On_Schedule"), 0).
:- not h(sat("cpsf:Received_On_Schedule"), 0). 
:- not h(sat("cpsf:Functionality"), 0). 
:- h(sat("cpsf:Functionality"), 1..5). 
:- h(sat(A), T), subconcern(A, B), not h(sat(B), T).
:- h(sat(B), T), addressedBy(A, B), not h(sat(A), T).
time(0..5).
