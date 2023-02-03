property(P) :- input(P,"rdf:type","cpsf:Property").
descr(P,D) :- input(P,"rdfs:comment",D).
atomic_statement(P,A) :- input(P,"cpsf:atomicStatement",A).
isAssertion(P) :- input(P,"cpsf:hasType","cpsf:PropertyType_Assertion").
concern(C) :- input(C,"rdf:type","cpsf:Concern").
aspect(A) :- input(A,"rdf:type","cpsf:Aspect").
subconcern(S,O) :- input(S,"cpsf:includesConcern",O).

addressedBy(C,P) :- input(P,"cpsf:addConcern",C).
component(C) :- input(C,"rdf:type","cpsf:Component").
relation(C,P,P) :- input(C,"cpsf:relateToProperty",P).

% ======Observation for Initial State

% ======Observation for Initial State
obs("cpsf:Maintenance_Regularly",true).
obs("cpsf:Control_Speed",false).
obs("cpsf:Record_25fps",true).
obs("cpsf:Send_Actions",true).
obs("cpsf:Control_Pulley",true).
obs("cpsf:Pulley_Release",true).
obs("cpsf:Pulley_Clench",true).
obs("cpsf:Moving_Up",true).
obs("cpsf:Moving_Down",true).
obs("cpsf:Halting",true).
obs("cpsf:Control_Moving",true).
obs("cpsf:Communicate_With_Other_Component",true).
obs("cpsf:detect_No_passenger",false).
obs(availablePatch("cpsf:Control_Speed"),true).
