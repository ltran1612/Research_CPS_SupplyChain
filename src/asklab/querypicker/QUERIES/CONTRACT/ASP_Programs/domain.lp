% Lumber Yard 
% produce(X, Z) causes  exists (Y), Y <= X, board(Y, Z)    
% deliver(Y, Z) causes  delivered(Y, Z) , board(X-Y, Z)    if    board(X, Z), Y <= X

% XYZ Homes 
% receive(X, Z) causes  available_board(X, Z)   if    delivered(X, Z)
% pay(X, C) causes  payment(X, C) , available_funds(Y-X) if    available_funds(Y), X >= Y  

% \executable a  if  \neg ab(a), \varphi 

% C1: L  responsible_for    board(144K, Q) , 1 <= Q  when  by_week 4    
% C2: L  responsible_for    delivered(144K, Q) , 2 <= Q  when  by_week 4  
% C3: H  responsible_for    payment(122K, board)  when  by_week 4    
% C4: H  responsible_for    exists(X), X <= 500K, payment(X, shipping)  when  by_week 4   

% P_L =   C2 :   match-customer-expected-grade , C4:   receive-due-payment  

% P_H =   C1 :   sufficient-material-for-building , C2 :   material-safe-for-building , 
%              C2:   material-sufficiently-durable , C4:   promptly-send-payment , 
%              C3:   acceptable-shipping-cost  
%
%  sufficient-material-for-building  addresses the TimeToMarket concern (Business aspect), 
%  material-safe-for-building  addresses Safety and Reliability (both under the Trustworthiness aspect),
%  material-sufficiently-durable  addresses Performance (Functional aspect),
%  promptly-send-payment  addresses Policy (Business aspect), and
%  acceptable-shipping-cost  addresses Cost (also under the Business aspect).

#external observation(delivered(X, 0..2), T) : number(X), time(T). 
#external observation(invoice(X, board), T) : number(X), time(T). 
#external observation(invoice(X, shipping), T) : number(X), time(T). 

time(0..4).
number(0..500). 
fluent(available_board(X,0..2)) :- number(X).  

holds(available_board(X,0..2), 0) :- number(X). 

holds(available_board(X+X',Y), T+1) :- time(T), 
					holds(available_board(X',Y), T),
					observation(delivered(X,Y), T). 	

#show holds/2.



