% test traditional cps ontology reasoning
% expect satisfaction
h("cpsf:Material_Safe_For_Production", 0).
:- not addressedBy("cpsf:Reliability", "cpsf:Material_Safe_For_Production").
:- not concern("cpsf:Reliability").
time(0..5).
:- not h(sat("cpsf:Reliability"), 0). 
:- h(sat("cpsf:Reliability"), 1..5). 
%
:- h("cpsf:On_Time_Payment", 0..5). 
:- h("cpsf:On_Time_Production", 0..5). 
:- h("cpsf:Product_Sufficiently_Durable", 0..5). 
:- h("cpsf:Received_On_Schedule", 0..5). 
:- h(sat("cpsf:Safety"), 0..5). 
:- h(sat("cpsf:Functionality"), 0..5). 
:- not h(sat("cpsf:Performance"), 0..5). 
:- h(sat(A), T), subconcern(A, B), not h(sat(B), T).
:- h(sat(B), T), addressedBy(A, B), not h(sat(A), T).
