% test 6 - test receiving item with quality - normal case and edge case
% expect satisfaction
% test state
time(0..10).
hold(available_quality_item, (test, (receiving_item, 1..10, 0)), 0).
hold(total_received_quality, (test, (agent1, receiving_item, 1..10, 0)), 0).
hold(total_received_quality, (test, (agent2, receiving_item, 1..10, 0)), 0).
inertial(test, available_quality_item, not_changed_last, ()).
inertial(test, total_received_quality, not_changed_last, ()).
inertial(agent1, delivered_quality, not_changed_last, ()).
inertial(agent2, delivered_quality, not_changed_last, ()).

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
pay_item(test, agent1, the_item).
pay_item(agent1, test, receiving_item, 1..10).
recv_item(test, agent1, receiving_item, 1..10).
recv_item(test, agent2, receiving_item, 1..10).
number(50).

% test condition
% test dynamic law 
% receive money 1
hold(delivered_quality, (agent1, (test, 1, receiving_item, 1, 50)), 1).
occur(receive_quality, (test, (agent1, 1, receiving_item, 1, 50)), 1).
:- not hold(delivered_quality, (agent1, (test, 1, receiving_item, 1, 50)), 2).
:- not action(test, receive_quality, (agent1, 1, receiving_item, 1, 50)).
:- not hold(available_quality_item, (test, (receiving_item, 1, 0)), 1).
:- not hold(available_quality_item, (test, (receiving_item, 1, 50)), 2).
:- not hold(total_received_quality, (test, (agent1, receiving_item, 1, 0)), 1).
:- not hold(total_received_quality, (test, (agent1, receiving_item, 1, 50)), 2).
% receive money 2 (with a gap from 1) 
hold(delivered_quality, (agent2, (test, 2, receiving_item, 1, 101)), 3).
occur(receive_quality, (test, (agent2, 2, receiving_item, 1, 101)), 3).
:- not hold(available_quality_item, (test, (receiving_item, 1, 50)), 3).
:- not hold(available_quality_item, (test, (receiving_item, 1, 151)), 4).
:- not hold(total_received_quality, (test, (agent2, receiving_item, 1, 0)), 3).
:- not hold(total_received_quality, (test, (agent2, receiving_item, 1, 101)), 4).
% % receive money 3 (continuation of 2)
hold(delivered_quality, (agent1, (test, 3, receiving_item, 1, 102)), 5).
occur(receive_quality, (test, (agent1, 3, receiving_item, 1, 102)), 5).
:- not hold(available_quality_item, (test, (receiving_item, 1, 151)), 5).
:- not hold(available_quality_item, (test, (receiving_item, 1, 253)), 6).
:- not hold(total_received_quality, (test, (agent1, receiving_item, 1, 50)), 5).
:- not hold(total_received_quality, (test, (agent1, receiving_item, 1, 152)), 6).

% % edge case
:- hold(available_quality_item, (test, (receiving_item, 1, _)), 11).

% % no same signature
% % test intertial rules
:- hold(available_quality_item, (test, (receiving_item, 1, 151)), 6..10).
:- not hold(available_quality_item, (test, (receiving_item, 1, 253)), 6..10).
:- not hold(total_received_quality, (test, (agent1, receiving_item, 1, 152)), 6..10).
:- not hold(total_received_quality, (test, (agent2, receiving_item, 1, 101)), 6..10).