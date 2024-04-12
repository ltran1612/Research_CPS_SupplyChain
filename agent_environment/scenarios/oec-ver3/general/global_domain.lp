% FLUENTS
fluent(sent_payment). 
fluent(received_payment). 
%
fluent(total_sent_payment). 
fluent(total_received_payment). 
%
fluent(available_funds).
%
fluent(total_produced).
fluent(total_produced_quality).
%
fluent(delivered).
fluent(delivered_quality).
%
fluent(total_delivered).
fluent(total_delivered_quality).
%
fluent(received).
fluent(received_quality).
%
fluent(total_received).
fluent(total_received_quality).
%
fluent(available_item).
fluent(available_quality_item).
%
fluent(enough_funds).
fluent(enough_item).
fluent(enough_item_quality).
fluent(can_receive).
fluent(can_receive_quality).
fluent(can_receive_money).
%
% type(S
type(sent_payment, parameterized). 
type(received_payment, parameterized). 
%
type(total_sent_payment, parameterized). 
type(total_received_payment, parameterized). 
%
type(available_funds, parameterized).
%
type(total_produced, parameterized).
type(total_produced_quality, parameterized).
%
type(delivered, parameterized).
type(delivered_quality, parameterized).
%
type(total_delivered, parameterized).
type(total_delivered_quality, parameterized).
%
type(received, parameterized).
type(received_quality, parameterized).
%
type(total_received, parameterized).
type(total_received_quality, parameterized).
%
type(available_item, parameterized).
type(available_quality_item, parameterized).
%
type(enough_funds, parameterized).
type(enough_item, parameterized).
type(enough_item_quality, parameterized).
type(can_receive, parameterized).
type(can_receive_quality, parameterized).
type(can_receive_money, parameterized).

%
operation(Name, Input, (Agent, (A, T, B, Amount)), T) :- 
    Name = record,
    require(Name, Input, T),
    Value = (Agent, A, B, Amount),
    Input = (Agent, Action, Value, Fluent, _),
    time(T). 
%
operation(Name, Input, (Agent, (A, T, B, C, Amount)), T) :- 
    Name = record,
    require(Name, Input, T),
    Value = (Agent, A, B, C, Amount),
    Input = (Agent, Action, Value, Fluent, _),
    time(T). 

% operations operation(Name, Input, (A, B, Amount + OldAmount), T+1) :- Name = increase_3_3_3, occur(Action, (Agent, A, B, Amount), T), hold(Fluent, (Agent, A, B, OldAmount), T), require(Input), Input = (Agent, Action, Fluent), time(T+1).
operation(Name, Input, (Agent, (OldAmount + Amount,)), T) :- 
    Name = increase,
    hold(Fluent, (Agent, (OldAmount,)), T), 
    require(Name, Input, T),
    Value = (Agent, A, B, C, Amount),
    Input = (Agent, Action, Value, Fluent, _),
    time(T). 
%
operation(Name, Input, (Agent, (A, C, OldAmount + Amount)), T) :- 
    Name = increase,
    hold(Fluent, (Agent, (A, C, OldAmount)), T), 
    require(Name, Input, T),
    Value = (Agent, A, B, C, Amount),
    Input = (Agent, Action, Value, Fluent, _),
    time(T). 
%
operation(Name, Input, (Agent, (A, C, D, OldAmount + Amount)), T) :- 
    Name = increase,
    hold(Fluent, (Agent, (A, C, D, OldAmount)), T), 
    require(Name, Input, T),
    Value = (Agent, A, B, C, D, Amount),
    Input = (Agent, Action, Value, Fluent, _),
    time(T). 
%
operation(Name, Input, (Agent, (A, OldAmount + Amount)), T) :- 
    Name = increase,
    hold(Fluent, (Agent, (A, OldAmount)), T), 
    require(Name, Input, T),
    Value = (Agent, A, Amount),
    Input = (Agent, Action, Value, Fluent, _),
    time(T). 

%
operation(Name, Input, (Agent, (C, OldAmount + Amount)), T) :- 
    Name = increase,
    hold(Fluent, (Agent, (C, OldAmount)), T), 
    require(Name, Input, T),
    Value = (Agent, A, B, C, Amount),
    Input = (Agent, Action, Value, Fluent, _),
    time(T). 
%
operation(Name, Input, (Agent, (C, D, OldAmount + Amount)), T) :- 
    Name = increase,
    hold(Fluent, (Agent, (C, D, OldAmount)), T), 
    require(Name, Input, T),
    Value = (Agent, A, B, C, D, Amount),
    Input = (Agent, Action, Value, Fluent, _),
    time(T). 
%
operation(Name, Input, (Agent, (B, C, OldAmount + Amount)), T) :- 
    Name = increase,
    hold(Fluent, (Agent, (B, C, OldAmount)), T), 
    require(Name, Input, T),
    Value = (Agent, A, B, C, Amount),
    Input = (Agent, Action, Value, Fluent, _),
    time(T). 
%
operation(Name, Input, (Agent, (B, C, D, OldAmount + Amount)), T) :- 
    Name = increase,
    hold(Fluent, (Agent, (B, C, D, OldAmount)), T), 
    require(Name, Input, T),
    Value = (Agent, A, B, C, D, Amount),
    Input = (Agent, Action, Value, Fluent, _),
    time(T). 
%
operation(Name, Input, (Agent, (A, B, OldAmount + Amount)), T) :- 
    Name = increase,
    hold(Fluent, (Agent, (A, B, OldAmount)), T), 
    require(Name, Input, T),
    Value = (Agent, A, B, Amount),
    Input = (Agent, Action, Value, Fluent, _),
    time(T). 
%
operation(Name, Input, (Agent, (A, B, C, OldAmount + Amount)), T) :- 
    Name = increase,
    hold(Fluent, (Agent, (A, B, C, OldAmount)), T), 
    require(Name, Input, T),
    Value = (Agent, A, B, C, Amount),
    Input = (Agent, Action, Value, Fluent, _),
    time(T). 
% 
operation(Name, Input, (Agent, (OldAmount - Amount,)), T) :- 
    Name = decrease,
    hold(Fluent, (Agent, (OldAmount,)), T), 
    require(Name, Input, T),
    Value = (Agent, A, B, Amount),
    Input = (Agent, Action, Value, Fluent, _),
    time(T). 
%
operation(Name, Input, (Agent, (B, OldAmount - Amount)), T) :- 
    Name = decrease,
    hold(Fluent, (Agent, (B, OldAmount)), T), 
    require(Name, Input, T),
    Value = (Agent, A, B, Amount),
    Input = (Agent, Action, Value, Fluent, _),
    time(T). 
%
operation(Name, Input, (Agent, (OldAmount - Amount)), T) :- 
    Name = decrease,
    hold(Fluent, (Agent, (OldAmount,)), T), 
    require(Name, Input, T),
    Value = (Agent, A, B, Amount),
    Input = (Agent, Action, Value, Fluent, _),
    time(T). 
%
operation(Name, Input, (Agent, (B, C, OldAmount - Amount)), T) :- 
    Name = decrease,
    hold(Fluent, (Agent, (B, C, OldAmount)), T), 
    require(Name, Input, T),
    Value = (Agent, A, B, C,  Amount),
    Input = (Agent, Action, Value, Fluent, _),
    time(T). 
% boolean operations
operation(Name, Input, true, T) :- 
    Name = greater,
    Result = OldAmount >= Amount, 
    hold(Fluent, (Agent, (OldAmount,)), T), 
    require(Name, Input, T),
    Value = (Agent, A, B, Amount),
    Input = (Agent, Action, Value, Fluent),
    time(T). 

%
operation(Name, Input, true, T) :- 
    Name = greater,
    Result = OldAmount >= Amount, 
    hold(Fluent, (Agent, (B, OldAmount)), T), 
    require(Name, Input, T),
    Value = (Agent, A, B, Amount),
    Input = (Agent, Action, Value, Fluent),
    time(T). 
    %
operation(Name, Input, true, T) :- 
    Name = greater,
    Result = OldAmount >= Amount, 
    hold(Fluent, (Agent, (B, C, OldAmount)), T), 
    require(Name, Input, T),
    Value = (Agent, A, B, C, Amount),
    Input = (Agent, Action, Value, Fluent),
    time(T). 
%
operation(Name, Input, true, T) :- 
    Name = greater,
    Result = OldAmount >= Amount, 
    hold(Fluent, (Agent, (A, B, C, OldAmount)), T), 
    require(Name, Input, T),
    Value = (Agent, A, B, C, Amount),
    Input = (Agent, Action, Value, Fluent),
    time(T). 
%
operation(Name, Input, true, T) :- 
    Name = greater,
    Result = OldAmount >= Amount,     
    hold(Fluent, (Agent, (A, B, C, D, OldAmount)), T), 
    require(Name, Input, T),
    Value = (Agent, A, B, C, D, Amount),
    Input = (Agent, Action, Value, Fluent),
    time(T). 
% %
operation(Name, Input, true, T) :- 
    Name = not_changed_last,
    Value = (A, _), 
    NewChanges = (A1, _),
    A1 != A,
    require(Name, Input, T),
    Input = (Agent, Fluent, (Agent, Value), (Agent, NewChanges), _),
    time(T+1). 

operation(Name, Input, true, T) :- 
    Name = not_changed_last,
    Value = (A, B, _),  
    NewChanges = (A1, B1, _),
    A1 != A,
    require(Name, Input, T),
    Input = (Agent, Fluent, (Agent, Value), (Agent, NewChanges), _),
    time(T+1). 
operation(Name, Input, true, T) :- 
    Name = not_changed_last,
    Value = (A, B, _),  
    NewChanges = (A1, B1, _),
    B != B1,
    require(Name, Input, T),
    Input = (Agent, Fluent, (Agent, Value), (Agent, NewChanges), _),
    time(T+1). 

operation(Name, Input, true, T) :- 
    Name = not_changed_last,
    Value = (A, B, C, _),  
    NewChanges = (A1, B1, C1, _),
    A1 != A,
    require(Name, Input, T),
    Input = (Agent, Fluent, (Agent, Value), (Agent, NewChanges), _),
    time(T+1). 
operation(Name, Input, true, T) :- 
    Name = not_changed_last,
    Value = (A, B, C, _),  
    NewChanges = (A1, B1, C1, _),
    B1 != B,
    require(Name, Input, T),
    Input = (Agent, Fluent, (Agent, Value), (Agent, NewChanges), _),
    time(T+1). 

operation(Name, Input, true, T) :- 
    Name = not_changed_last,
    Value = (A, B, C, _),  
    NewChanges = (A1, B1, C1, _),
    C1 != C,
    require(Name, Input, T),
    Input = (Agent, Fluent, (Agent, Value), (Agent, NewChanges), _),
    time(T+1). 

operation(Name, Input, true, T) :- 
    Name = always_inertial,
    require(Name, Input, T),
    Input = (Agent, Fluent, (Agent, Value), (Agent, NewChanges), _),
    time(T+1). 
%
operation(Name, Input, true, T) :- 
    Name = has,
    require(Name, Input, T),
    not hold(ReceivedFluent, (Agent, (SourceAgent, TimeOfSource, ReceiveTarget, Amount)), T),
    hold(SourceFluent, (SourceAgent, (Agent, TimeOfSource, ReceiveTarget, Amount)), T),
    Input = (Agent, Action, Value, (ReceivedFluent, SourceFluent, SourceAgent, ReceiveTarget)),
    time(T+1). 
operation(Name, Input, true, T) :- 
    Name = has,
    require(Name, Input, T),
    not hold(ReceivedFluent, (Agent, (SourceAgent, TimeOfSource, ReceiveTarget, A, Amount)), T),
    hold(SourceFluent, (SourceAgent, (Agent, TimeOfSource, Target, A, Amount)), T),
    Input = (Agent, Action, Value, (ReceivedFluent, SourceFluent, SourceAgent, ReceiveTarget, A)),
    time(T+1). 

boolean_condition(greater).
boolean_condition(has).
boolean_condition(not_changed_last).
boolean_condition(always_inertial).
operation(Name, Input, false, T) :- 
    boolean_condition(Name),
    not operation(Name, Input, true, T), 
    require(Name, Input, T),
    time(T). 