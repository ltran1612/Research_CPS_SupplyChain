#const maxTime=4. 

step(0..maxTime). 

example(case). 

%%% example 1 

assume(lumber_board(150000,1)) :- example(1).  

%%% example 2

assume(lumber_board(100000,1)) :- example(2). 
assume(lumber_board(50000,2))   :- example(2).

%%% example 3

assume(lumber_board(100000,1)) :- example(3). 
%assume(lumber_board(50000,2))   :- example(2).


grade(0..3). 

init(board(0,0..2)).
init(available_fund(200000)). 

%amount(1000).
amount(5000).
amount(10000).
amount(20000).
amount(30000).
amount(40000).
%amount(44000).
amount(50000).
amount(100000).
amount(150000). 

holds(lumber_board(X,Y), 0) :-  assume(lumber_board(X,Y)). 
holds(lumber_board(0,G), 0)  :-  grade(G), not assume(lumber_board(_,G)). 
holds(lumber_board(X-Z,Y), T+1) :-  step(T), holds(lumber_board(X,Y), T), observation(delivered(Z,Y),T).
holds(lumber_board(X,Y), T+1) :-  step(T), holds(lumber_board(X,Y), T), not delivered(Y,T).
delivered(Y,T) :- observation(delivered(_,Y), T).                                             

{observation(delivered(X,Y), T) : amount(X)} 1 :- step(T), holds(lumber_board(X',Y), T).

:- step(T), delivered(Q,T), Q > 1, holds(lumber_board(X,1), T), X > 0.  

:- step(T), holds(lumber_board(X',Y), T), observation(delivered(X,Y), T), X > X'. 

:- step(T), delivered(Q,T), Q > 1, holds(board(140000,1), T).  

:- step(T), holds(board(X',1), T), observation(delivered(X,Y), T), Y >=1, X+X' >140000. 

% :~ holds(lumber_board(M,G), maxTime+1), N=100000*G. [-N@G, M] 

%#maximize {M : holds(lumber_board(M, G), maxTime+1),grade(G)}. 

%observation(delivered(100000,1), 0).
%observation(delivered(40000,1), 1).

holds(board(X,Y), 0) :- init(board(X,Y)).

holds(board(X+X',Y), T+1) :- step(T), holds(board(X',Y), T), observation(delivered(X,Y),T).
holds(board(X,Y), T+1)  :- step(T), holds(board(X,Y), T), not delivered(Y, T).                                                

holds(board_cost(X-B), T) :- step(T), X = #sum {Y *10 : holds(board(Y, Q), T), Q >= 1}, holds(paid(B, board), T).

holds(available_fund(X), 0):- init(available_fund(X)). 
holds(available_fund(0), 0):- not init(available_fund(_)). 

holds(paid(0, board), 0).
holds(paid(0, shipping), 0).                                              

{occurs(pay(X, board), T) : amount(X)} 1 :-  step(T),   holds(available_fund(Y), T), Y > 0. 

{occurs(pay(X, shipping), T) : amount(X)} 1 :- step(T),   holds(available_fund(Y), T), Y > 0.  

%occurs(pay(50000,shipping),3).
%occurs(pay(100000,board),3).
%occurs(pay(20000,board),2).

:- step(T), holds(available_fund(X'), T), #sum{X,Y : occurs(pay(X, Y), T)} > X'.  

:- step(T), occurs(pay(X, shipping), T), holds(board_cost(0), T).  

:- step(T), occurs(pay(X, shipping), T), holds(paid(Y, shipping), T), Y+X > 50000.  

:- step(T), occurs(pay(X, board), T), holds(board_cost(0), T).  


% :- step(T), occurs(pay(X, board), T), holds(board_cost(Y), T), Y<X.  

ab(1):- step(T), Z = #sum{Y, B : occurs(pay(Y, B), T)}, holds(available_fund(X), T), X < Z.  

holds(available_fund(X-Z), T+1) :- step(T), holds(available_fund(X), T), 
                                                       Z = #sum{Y, B : occurs(pay(Y, B), T)}, X >= Z. 

holds(available_fund(X), T+1) :- step(T), holds(available_fund(X), T), 
                                                       Z = #sum{Y, B : occurs(pay(Y, B), T)}, X < Z. 
                                                   
holds(paid(X+Z, Y), T+1) :- step(T), holds(paid(X, Y), T), occurs(pay(Z, Y), T), not ab(1).                                                      

holds(paid(X, Y), T+1) :- step(T),  holds(paid(X, Y), T),  #count{X' : occurs(pay(X',Y), T)} == 0.                                                       

holds(paid(X, Y), T+1) :- step(T),  holds(paid(X, Y), T),  #count{X' : occurs(pay(X',Y), T)} > 0, ab(1).                                                       

%%
%%holds(available_fund(X-Y), T+1) :- step(T), holds(available_fund(X), T), Y = #sum{Z, Q : occurs(pay(Z, Q), T)}. 
%%
%%holds(available_fund(A), T+1) :- step(T), holds(available_fund(A), T),  #count{X,Y : occurs(pay(X,Y), T)} == 0. 
%%                                                   
%%holds(paid(X+Z, Y), T+1) :- step(T), holds(paid(X, Y), T), occurs(pay(Z, Y), T).                                                      
%%
%%holds(paid(X, Y), T+1) :- step(T),  holds(paid(X, Y), T),  #count{X' : occurs(pay(X',Y), T)} == 0.                                                     
                                               
% C1: L  responsible_for    board(144K, Q) , 1 <= Q  when  by_week 4    
% C2: L  responsible_for    delivered(144K, Q) , 1 <= Q  when  by_week 4  
% C3: H  responsible_for    payment(122K, board)  when  by_week 4    
% C4: H  responsible_for    exists(X), X >= 50K, payment(X, shipping)  when  by_week 4   

clause(c1, lumber, phi_1, by(4)). 
clause(c2, lumber, phi_2, by(4)). 
clause(c3, homes, phi_3, by(4)). 
clause(c4, homes, phi_4, by(4)).  

%%% condition whether clause 1 is satisfied 

holds(phi_1, T) :- step(T), #sum{X,Q,T' : observation(delivered(X, Q), T'), Q>=1, T>=T'} >= 140000.  

%%% condition whether clause 2 is satisfied 

holds(phi_2, T) :- step(T), holds(board(140000, 1), T).  

replacement(X,Q) :- 
	step(T), not holds(board(140000, 1), T), 
	holds(board(X,Q), T), Q>1,X>0,  
	#sum{X1,Q1 : holds(board(X1, Q1), T), Q1>=1} >= 140000.  

holds(phi_2, T) :-  step(T), not holds(board(140000, 1), T), 
	#sum{X,Q : holds(board(X, Q), T), Q>=1} >= 140000.  


%%% paying the full contract 

holds(phi_3, T) :- step(T), holds(paid(120000, board), T).  

%%% paying as needed 

holds(phi_3, T) :- step(T), holds(board_cost(0), T). 

%%% paying the full contract for shipping 

holds(phi_4, T) :- step(T), holds(paid(50000, shipping), T).  

%%% satisfaction of clauses 

satisfies(C, T) :- step(T), clause(C, _, F, by(N)), T<=N, holds(F, T). 

not_satisfies(C, T) :- step(T), clause(C, _, F, by(N)), T<=N, not holds(F, T). 
%%% 
%%
%%not_ok(c1) :- not satisfies(c1,  maxTime). 
%%not_ok(c2) :- not satisfies(c2, maxTime). 
%%not_ok(c3) :- not satisfies(c3, maxTime). 
%%not_ok(c4) :- not satisfies(c4, maxTime). 

%
%ok(c1) :- satisfies(c1,  maxTime). 
%ok(c2) :- satisfies(c2, maxTime). 
%ok(c3) :- satisfies(c3, maxTime). 
%ok(c4) :- satisfies(c4, maxTime). 

 
good(N) :- N = #count{C : satisfies(C, maxTime)}.
 
 #maximize {N : good(N)}. 

%%%

%#maximize {Z : holds(available_fund(Z), maxTime+1)}. 

#show.

% #show holds/2. 
#show occurs/2. 
#show observation/2. 
#show received(board(X,Y), T) : observation(delivered(X,Y), T).
#show satisfies(X) : satisfies(X, maxTime). 
#show not_satisfies(X) : not_satisfies(X, maxTime).  
#show replacement/2. 
 #show good/1. 

