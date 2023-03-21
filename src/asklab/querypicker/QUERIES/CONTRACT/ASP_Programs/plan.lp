time(0..4).

init(available_fund(100000)).

holds(available_fund(X), 0):- init(available_fund(X)).  

0 {occurs(pay(T, board), T)} 1 :-  time(T). 

&diff{(T,board) - Y} <= 0 :- time(T), occurs(pay(T, board), T) , holds(available_fund(Y), T).   
&diff{(T,board) - Y} <= -Y' :- time(T), occurs(pay(T, board), T) , holds(available_fund(Y), T), holds(available_fund(Y'), T+1).   

:- not holds(available_fund(90000), 4).

%
%&diff{(T,shipping) - Y} <= 0 :- occurs(pay(T, shipping), T) , holds(available_fund(Y), T).   

%#show dl/2. 
%#show occurs/2.
%#show holds/2. 
