#show. 

%% #show fluent/1. 
#show sat(X) : holds(sat(X), maxTime). 
#show sat(X,Y) : holds(sat(X,Y), maxTime). 
#show satisfies(C)        :  satisfies(C, maxTime). 
#show not_satisfies(C) : not_satisfies(C, maxTime).
#show ab("Insufficient_funding_for_all_tasks") : ab(1). 

%% #show occurs/2. 