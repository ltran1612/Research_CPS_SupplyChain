% test 5 - test receiving money - normal case and edge case 
% expect satisfaction
% test state
time(0..10).
hold(available_funds, (test, (0,)), 0).
hold(total_received_payment, (test, (agent1, receiving_item, 0)), 0).
hold(total_received_payment, (test, (agent2, receiving_apple, 0)), 0).
inertial(test, available_funds, not_changed_last, ()).
inertial(test, total_received_payment, not_changed_last, ()).
inertial(agent1, sent_payment, not_changed_last, ()).
inertial(agent2, sent_payment, not_changed_last, ()).

operation(Name, Input, true, T) :- 
    Name = not_changed_last,
    Value = (A, _), 
    NewChanges = (A1, _),
    A1 != A,
    require(Name, Input, T),
    Input = (Agent, Fluent, (Agent, Value), (Agent, NewChanges), _),
    time(T). 

operation(Name, Input, true, T) :- 
    Name = not_changed_last,
    Value = (A, B, _),  
    NewChanges = (A1, B1, _),
    A1 != A,
    require(Name, Input, T),
    Input = (Agent, Fluent, (Agent, Value), (Agent, NewChanges), _),
    time(T). 
operation(Name, Input, true, T) :- 
    Name = not_changed_last,
    Value = (A, B, _),  
    NewChanges = (A1, B1, _),
    B != B1,
    require(Name, Input, T),
    Input = (Agent, Fluent, (Agent, Value), (Agent, NewChanges), _),
    time(T). 

operation(Name, Input, true, T) :- 
    Name = not_changed_last,
    Value = (A, B, C, _),  
    NewChanges = (A1, B1, C1, _),
    A1 != A,
    require(Name, Input, T),
    Input = (Agent, Fluent, (Agent, Value), (Agent, NewChanges), _),
    time(T). 
operation(Name, Input, true, T) :- 
    Name = not_changed_last,
    Value = (A, B, C, _),  
    NewChanges = (A1, B1, C1, _),
    B1 != B,
    require(Name, Input, T),
    Input = (Agent, Fluent, (Agent, Value), (Agent, NewChanges), _),
    time(T). 

operation(Name, Input, true, T) :- 
    Name = not_changed_last,
    Value = (A, B, C, _),  
    NewChanges = (A1, B1, C1, _),
    C1 != C,
    require(Name, Input, T),
    Input = (Agent, Fluent, (Agent, Value), (Agent, NewChanges), _),
    time(T). 
receiving_reason(test, agent1, receiving_item).
receiving_reason(test, agent2, receiving_apple).
pay_item(agent1, test, receiving_item).
number(50).
number(101).
number(102).

% test condition
% test dynamic law 
hold(sent_payment, (agent1, (test, 0, receiving_item, 50)), 0).
%
occur(receive_money, (test, (agent1, 0, receiving_item, 50)), 1).
:- not hold(available_funds, (test, (0,)), 1).
:- not hold(available_funds, (test, (50,)), 2).
%
:- not hold(total_received_payment, (test, (agent1, receiving_item, 0)), 0..1).
:- not hold(total_received_payment, (test, (agent1, receiving_item, 50)), 2..3).

% receive money 2 (with a gap from 1) 
hold(sent_payment, (agent1, (test, 1, receiving_item, 101)), 1).
occur(receive_money, (test, (agent1, 1, receiving_item, 101)), 3).
:- not hold(available_funds, (test, (50,)), 3).
:- not hold(available_funds, (test, (151,)), 4..5).
%
:- not hold(total_received_payment, (test, (agent1, receiving_item, 50)), 3).
:- not hold(total_received_payment, (test, (agent1, receiving_item, 151)), 4..5).

% % receive money 3 (continuation of 2)
hold(sent_payment, (agent1, (test, 2, receiving_item, 102)), 2).
occur(receive_money, (test, (agent1, 2, receiving_item, 102)), 5).
:- not hold(available_funds, (test, (151,)), 5).
:- not hold(available_funds, (test, (253,)), 6..7).
%
:- not hold(total_received_payment, (test, (agent1, receiving_item, 253)), 6..10).
%
:- hold(total_received_payment, (test, (agent1, receiving_item, 151)), 6..10).
:- hold(total_received_payment, (test, (agent1, receiving_item, 50)), 6..10).
:- hold(total_received_payment, (test, (agent1, receiving_item, 0)), 6..10).

% % receive money 4 for apple (continuation of 2)
hold(sent_payment, (agent2, (test, 3, receiving_apple, 102)), 3).
occur(receive_money, (test, (agent2, 3, receiving_apple, 102)), 7).
:- not hold(total_received_payment, (test, (agent2,receiving_apple, 102)), 8..10).
% :- not changed(test, action, _, total_received_payment, _, 8).
% :- not hold(total_received_payment, (test, (agent2,receiving_apple, 0)), 8).
% :- not hold(total_received_payment, (test, (agent2,receiving_apple, 0)), 0..7).
% :- hold(total_received_payment, (test, (agent2,receiving_apple, 102)), 0..7).
% :- hold(total_received_payment, (test, (agent2,receiving_item, 151)), 7..10).
% :- hold(total_received_payment, (test, (agent2, receiving_item, 50)), 7..10).
% :- hold(total_received_payment, (test, (agent2,receiving_item, 0)), 7..10).
% :- not hold(available_funds, (test, (355,)), 8..10).
% :- hold(available_funds, (test, (253,)), 8..10).
:- failed(_).
:- failed(_, _, _).