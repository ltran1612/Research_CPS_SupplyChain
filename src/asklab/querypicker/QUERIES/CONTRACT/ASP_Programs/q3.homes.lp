#const maxTime=4.
 step(0..maxTime). 

%% parameter 

example(case).		% case = 1, 2, 3
fund(pool).                 % pool = 1, 2 

% initial situation - standard 
init(board(0,0..2)).

% observations along the history 

%% Example 1 
%% nothing is satisfied 

observation(delivered(5000,1), 1)       :- example(1).  
observation(delivered(500,2), 1)         :- example(1).    

%% Example 2
%% Pay 50K for shipping - clause 4 is satisfied  

observation(delivered(5000,1), 1)       :- example(2).  
observation(delivered(500,2), 1)         :- example(2).    
observation(paid(50000, shipping), 3):- example(2).   

%% Example 3
%% Pay 50K for shipping - clause 4 is satisfied  
%% Delivery all boards - clause 2 is satisfied 
%% Pay enough for board - clause 3 is satisfied 
%% Delivery all boards - clause 1 is satisfied 


observation(delivered(5000,1), 1)      :- example(3).  
observation(delivered(500,1), 2)        :- example(3).    
observation(delivered(138500,1), 3)  :- example(3).    

observation(paid(50000, board), 2)    :- example(3).  
observation(paid(75000, board), 3)    :- example(3). 
observation(paid(50000, shipping), 3):- example(3).   

% sufficient funding 
init(available_fund(200000))   :- fund(1).   

% insufficient funding 
init(available_fund(100000))   :- fund(2).   


%% init(available_fund(100000)). 

% defining initial state 

holds(available_fund(X), 0):- init(available_fund(X)). 
holds(available_fund(0), 0):- not init(available_fund(_)).

holds(paid(0, board), 0).
holds(paid(0, shipping), 0).

% assimilate observations 

delivered(Y,T) :- observation(delivered(_,Y), T).                                             

%                                               
holds(board(X,Y), 0) :- init(board(X,Y)).

holds(board(X+X',Y), T+1) :- step(T), holds(board(X',Y), T),
                                              observation(delivered(X,Y),T).

holds(board(X,Y), T+1)  :- step(T), holds(board(X,Y), T), not delivered(Y, T).                                                

holds(board_cost(X), T) :- step(T), X = #sum {Y *10 : holds(board(Y, Q), T), Q >= 1}.

occurs(pay(X, Y), T) :- step(T), observation(paid(X, Y), T). 

ab(1):- step(T), Z = #sum{Y, B : occurs(pay(Y, B), T)}, holds(available_fund(X), T), X < Z.  

holds(available_fund(X-Z), T+1) :- step(T), holds(available_fund(X), T), 
                                                       Z = #sum{Y, B : occurs(pay(Y, B), T)}, X >= Z. 

holds(available_fund(X), T+1) :- step(T), holds(available_fund(X), T), 
                                                       Z = #sum{Y, B : occurs(pay(Y, B), T)}, X < Z. 
                                                   
holds(paid(X+Z, Y), T+1) :- step(T), holds(paid(X, Y), T), occurs(pay(Z, Y), T), not ab(1).                                                      

holds(paid(X, Y), T+1) :- step(T),  holds(paid(X, Y), T),  #count{X' : occurs(pay(X',Y), T)} == 0.                                                       

holds(paid(X, Y), T+1) :- step(T),  holds(paid(X, Y), T),  #count{X' : occurs(pay(X',Y), T)} > 0, ab(1).                                                       

                                               
% C1: L  responsible_for    board(144K, Q) , 1 <= Q  when  by_week 4    
% C2: L  responsible_for    delivered(144K, Q) , 2 <= Q  when  by_week 4  
% C3: H  responsible_for    payment(122K, board)  when  by_week 4    
% C4: H  responsible_for    exists(X), X >= 50K, payment(X, shipping)  when  by_week 4   

clause(c1, lumber, phi_1, by(4)). 
clause(c2, lumber, phi_2, by(4)). 
clause(c3, homes, phi_3, by(4)). 
clause(c4, homes, phi_4, by(4)). 

holds(phi_1, T) :- step(T), #sum{X : observation(delivered(X, Q), T'), Q>=1, T>=T'} >= 144000.  
holds(phi_2, T) :- step(T), #sum{X : holds(board(X, Q), T), Q>=1} >= 144000.  
holds(phi_3, T) :- step(T), holds(paid(Y, board), T), Y >= 122000.  
holds(phi_4, T) :- step(T), holds(paid(X, shipping), T), X >= 50000.  

satisfies(C, T) :- step(T), clause(C, _, F, by(N)), T<=N, holds(F, T). 
not_satisfies(C, T) :- step(T), clause(C, _, F, by(N)), T<=N, not holds(F, T). 
 
%% private_part(c1,  
 
%%% property("sufficient_material_for_building").  %% C1  %% "cpsf:TimeToMarket"  %% business aspect   
%%% property("material_safe_for_building").          %% C2  %% "cpsf:Reliability" and "cpsf:Safety" %% Trustworthiness 
%%% property("material_sufficiently_durable").      %% C2  %% "cpsf:Performance"
%%% property("promptly_send_payment").            %% C4  %% "cpsf:Policy"
%%% property("acceptable_shipping_cost").          %% C3  %% "cpsf:Cost"

%%% addressedBy("cpsf:TimeToMarket","sufficient_material_for_building").  
%%% addressedBy("cpsf:Cost","acceptable_shipping_cost"). 
%%% addressedBy("cpsf:Policy","promptly_send_payment"). 
%%% addressedBy("cpsf:Performance","material_sufficiently_durable").
%%% addressedBy("cpsf:Reliability","material_safe_for_building").
%%% addressedBy("cpsf:Safety","material_safe_for_building"). 

holds(sat("sufficient_material_for_building"), T):- step(T), holds(phi_1,T).
-holds(sat("sufficient_material_for_building"), T):- step(T), not holds(phi_1,T).

holds(sat("material_safe_for_building"), T):- step(T), holds(phi_2,T).
-holds(sat("material_safe_for_building"), T):- step(T), not holds(phi_2,T).

holds(sat("material_sufficiently_durable"), T):- step(T), holds(phi_2,T).
-holds(sat("material_sufficiently_durable"), T):- step(T), not holds(phi_2,T).

holds(sat("acceptable_shipping_cost"), T):- step(T), holds(phi_3,T).
-holds(sat("acceptable_shipping_cost"), T):- step(T), not holds(phi_3,T).

holds(sat("promptly_send_payment"), T):- step(T), holds(phi_4,T).
-holds(sat("promptly_send_payment"), T):- step(T), not holds(phi_4,T).

