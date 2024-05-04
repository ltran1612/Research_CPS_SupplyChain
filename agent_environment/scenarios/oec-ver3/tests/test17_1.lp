% test cps conjunction
% expect satisfaction
time(0..5).
h("cpsf:On_Time_Payment", 1).
h("cpsf:On_Time_Production", 1).
:- not h("cpsf:On_Time_Payment", 1). 
:- not h("cpsf:On_Time_Production", 1). 
:- not conjunction("cpsf:g6").
:- not formula("cpsf:g6").
:- disjunction("cpsf:g6").
:- not property("cpsf:On_Time_Payment"). 
:- not property("cpsf:On_Time_Production"). 
:- not input("cpsf:On_Time_Production", "cpsf:memberOf", "cpsf:g6"). 
:- not member("cpsf:On_Time_Production", "cpsf:g6"). 
:- not h("cpsf:g6", 1).
:- h("cpsf:g6", 0).
:- not addressedBy("cpsf:Functionality", "cpsf:g6").
% %
:- h("cpsf:On_Time_Payment", 2..5). 
:- h("cpsf:On_Time_Production", 2..5). 
:- not h(sat("cpsf:Functionality"), 1). 
:- h(sat("cpsf:Functionality"), 0). 
:- h(sat("cpsf:Functionality"), 4..5). 
%
:- h("cpsf:Product_Sufficiently_Durable", 0..5). 
:- h("cpsf:Received_On_Schedule", 0..5). 
:- h(sat("cpsf:Reliability"), 0..5). 
:- h(sat("cpsf:Safety"), 0..5). 
:- not h(sat("cpsf:Performance"), 0..5). 
:- h(sat(A), T), subconcern(A, B), not h(sat(B), T).
:- h(sat(B), T), addressedBy(A, B), not h(sat(A), T).
