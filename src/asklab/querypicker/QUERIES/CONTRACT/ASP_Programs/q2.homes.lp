#const maxTime=4.

time(0..maxTime). 

% observations along the history 

observation(delivered(5000,1), 1). 
observation(delivered(500,2), 2).  
% observation(delivered(138500,2), 3).  
observation(paid(50000, board), 2). 
observation(paid(50000, shipping), 3). 
observation(paid(75000, board), 3). 

% initial situation 

init(board(0,0..2)).
init(available_fund(200000)). 

% defining initial state 

holds(available_fund(X), 0):- init(available_fund(X)). 
holds(available_fund(0), 0):- not init(available_fund(_)). 

holds(paid(0, board), 0).
holds(paid(0, shipping), 0).

% assimilate observations 

delivered(Y,T) :- observation(delivered(_,Y), T).                                             

%                                               
holds(board(X,Y), 0) :- init(board(X,Y)).

holds(board(X+X',Y), T+1) :- time(T), holds(board(X',Y), T),
                                              observation(delivered(X,Y),T).

holds(board(X,Y), T+1)  :- time(T), holds(board(X,Y), T), not delivered(Y, T).                                                

holds(board_cost(X), T) :- time(T), X = #sum {Y *10 : holds(board(Y, Q), T), Q >= 1}.

occurs(pay(X, Y), T) :- time(T), observation(paid(X, Y), T). 

:- time(T), occurs(pay(X, Y), T), holds(available_fund(X'), T), X' < X.  

holds(available_fund(X-Y), T+1) :- time(T), holds(available_fund(X), T), 
                                                       occurs(pay(Y, _), T). 

holds(available_fund(A), T+1) :- time(T), holds(available_fund(A, _), T), 
                                                    #count{X,Y : occurs(pay(X,Y), T)} == 0. 
                                                   
holds(paid(X+Z, Y), T+1) :- time(T), holds(paid(X, Y), T), occurs(pay(Z, Y), T).                                                      

holds(paid(X, Y), T+1) :- time(T),  holds(paid(X, Y), T),  #count{X' : occurs(pay(X',Y), T)} == 0.                                                     
                                               
% C1: L  responsible_for    board(144K, Q) , 1 <= Q  when  by_week 4    
% C2: L  responsible_for    delivered(144K, Q) , 2 <= Q  when  by_week 4  
% C3: H  responsible_for    payment(122K, board)  when  by_week 4    
% C4: H  responsible_for    exists(X), X >= 50K, payment(X, shipping)  when  by_week 4   

% clause(1, lumber, phi_1, by(4)). 

clause(2, lumber, phi_2, by(4)). 
clause(3, homes, phi_3, by(4)). 
clause(4, homes, phi_4, by(4)). 

holds(phi_1, T) :- time(T), #sum{X : observation(delivered(X, Q), T'), Q>=1, T>=T'} >= 144000.  
holds(phi_2, T) :- time(T), #sum{X : holds(board(X, Q), T), Q>=1} >= 144000.  
holds(phi_3, T) :- time(T), holds(paid(Y, board), T), Y >= 122000.  
holds(phi_4, T) :- time(T), holds(paid(X, shipping), T), X >= 50000.  

satisfies(C, T) :- time(T), clause(C, _, F, by(N)), T<=N, holds(F, T). 
not_satisfies(C, T) :- time(T), clause(C, _, F, by(N)), T<=N, not holds(F, T). 

% #show holds/2. 

#show satisfies(C)        :  satisfies(C, maxTime). 
#show not_satisfies(C) : not_satisfies(C, maxTime).
 

