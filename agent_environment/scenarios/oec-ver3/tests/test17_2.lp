% test cps disjunction 
% expect satisfaction
time(0..5).
h("cpsf:Product_Sufficiently_Durable", 1).
h("cpsf:Received_On_Schedule", 1).
:- not h("cpsf:Received_On_Schedule", 1). 
:- not h("cpsf:Product_Sufficiently_Durable", 1). 
:- not disjunction("cpsf:g7").
:- not formula("cpsf:g7").
:- conjunction("cpsf:g7").
:- not property("cpsf:Received_On_Schedule"). 
:- not property("cpsf:Product_Sufficiently_Durable"). 
:- not input("cpsf:Product_Sufficiently_Durable", "cpsf:memberOf", "cpsf:g7"). 
:- not member("cpsf:Product_Sufficiently_Durable", "cpsf:g7"). 
:- not h("cpsf:g7", 1).
:- h("cpsf:g7", 0).
:- not addressedBy("cpsf:Safety", "cpsf:g7").
:- not addressedBy("cpsf:Safety", "cpsf:Material_Safe_For_Production").
% % %
:- h("cpsf:Received_On_Schedule", 3..5). 
:- h("cpsf:Product_Sufficiently_Durable", 3..5). 
:- h("cpsf:Material_Safe_For_Production", 1).
:- not property("cpsf:Material_Safe_For_Production").
%
h("cpsf:Material_Safe_For_Production", 2).

h("cpsf:Product_Sufficiently_Durable", 2).
h("cpsf:Received_On_Schedule", 2).
:- h(sat("cpsf:Safety"), 1). 
:- not h(sat("cpsf:Safety"), 2). 
:- h(sat("cpsf:Safety"), 0). 
:- h(sat("cpsf:Safety"), 3..5). 
% %
:- h(sat("cpsf:Reliability"), 3..5). 
:- h(sat("cpsf:Reliability"), 0). 
:- not h(sat("cpsf:Reliability"), 2). 
:- h(sat("cpsf:Functionality"), 0..5). 
:- not h(sat("cpsf:Performance"), 0..5). 
:- h(sat(A), T), subconcern(A, B), not h(sat(B), T).
:- h(sat(B), T), addressedBy(A, B), not h(sat(A), T).

%
%

:- not subconcern("cpsf:Safety", "cpsf:Human_Safety").
:- not h(sat("cpsf:Human_Safety"), 0..5).