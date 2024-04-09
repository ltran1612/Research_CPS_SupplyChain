% operations operation(Name, Input, (A, B, Amount + OldAmount), T+1) :- Name = increase_3_3_3, occur(Action, (Agent, A, B, Amount), T), hold(Fluent, (Agent, A, B, OldAmount), T), require(Input), Input = (Agent, Action, Fluent), time(T+1).
%
operation(Name, Input, (OldAmount - Amount), T) :- 
    Name = decrease_3_1_1,
    occur(Action, (Agent, A, B, Amount), T), 
    hold(Fluent, (Agent, OldAmount), T), 
    require(Input),
    Input = (Agent, Action, Fluent),
    time(T). 
%
operation(Name, Input, (OldAmount + Amount), T) :- 
    Name = increase_3_1_1,
    occur(Action, (Agent, A, B, Amount), T), 
    hold(Fluent, (Agent, OldAmount), T), 
    require(Input),
    Input = (Agent, Action, Fluent),
    time(T). 
% 
operation(Name, Input, (C, OldAmount + Amount), T) :- 
    Name = increase_4_2_2,
    occur(Action, (Agent, A, B, C, Amount), T), 
    hold(Fluent, (Agent, C, OldAmount), T), 
    require(Input),
    Input = (Agent, Action, Fluent),
    time(T). 
%
operation(Name, Input, (C, D, OldAmount + Amount), T) :- 
    Name = increase_5_3_3,
    occur(Action, (Agent, A, B, C, D, Amount), T), 
    hold(Fluent, (Agent, C, D, OldAmount), T), 
    require(Input),
    Input = (Agent, Action, Fluent),
    time(T). 
%
operation(Name, Input, (B, C, OldAmount + Amount), T) :- 
    Name = increase_4_3_3,
    occur(Action, (Agent, A, B, C, Amount), T), 
    hold(Fluent, (Agent, B, C, OldAmount), T), 
    require(Input),
    Input = (Agent, Action, Fluent),
    time(T). 
%
operation(Name, Input, (B, C, D, OldAmount + Amount), T) :- 
    Name = increase_5_4_4,
    occur(Action, (Agent, A, B, C, D, Amount), T), 
    hold(Fluent, (Agent, B, C, D, OldAmount), T), 
    require(Input),
    Input = (Agent, Action, Fluent),
    time(T). 
%
operation(Name, Input, (A, OldAmount + Amount), T) :- 
    Name = increase_2_2_2,
    occur(Action, (Agent, A, Amount), T), 
    hold(Fluent, (Agent, A, OldAmount), T), 
    require(Input),
    Input = (Agent, Action, Fluent),
    time(T). 
%
operation(Name, Input, (A, B, OldAmount + Amount), T) :- 
    Name = increase_3_3_3,
    occur(Action, (Agent, A, B, Amount), T), 
    hold(Fluent, (Agent, A, B, OldAmount), T), 
    require(Input),
    Input = (Agent, Action, Fluent),
    time(T). 
%
operation(Name, Input, (A, B, C, OldAmount + Amount), T) :- 
    Name = increase_4_4_4,
    occur(Action, (Agent, A, B, C, Amount), T), 
    hold(Fluent, (Agent, A, B, C, OldAmount), T), 
    require(Input),
    Input = (Agent, Action, Fluent),
    time(T). 
%
operation(Name, Input, (B, OldAmount - Amount), T) :- 
    Name = decrease_3_2_2,
    occur(Action, (Agent, A, B, Amount), T), 
    hold(Fluent, (Agent, B, OldAmount), T), 
    require(Input),
    Input = (Agent, Action, Fluent),
    time(T). 
%
operation(Name, Input, (B, C, OldAmount - Amount), T) :- 
    Name = decrease_4_3_3,
    occur(Action, (Agent, A, B, C, Amount), T), 
    hold(Fluent, (Agent, B, C, OldAmount), T), 
    require(Input),
    Input = (Agent, Action, Fluent),
    time(T). 

% boolean operations
operation(Name, Input, (Amount, OldAmount, Result), T) :- 
    Name = greater_3_1_3,
    Result = Amount >= OldAmount, 
    occur(Action, (Agent, A, B, Amount), T), 
    hold(Fluent, (Agent, OldAmount), T), 
    require(Input),
    Input = (Agent, Action, Fluent),
    time(T). 
%
operation(Name, Input, (Amount, OldAmount, Result), T) :- 
    Name = greater_3_2_3,
    Result = Amount >= OldAmount, 
    occur(Action, (Agent, A, B, Amount), T), 
    hold(Fluent, (Agent, B, OldAmount), T), 
    require(Input),
    Input = (Agent, Action, Fluent),
    time(T). 
%
operation(Name, Input, (Amount, OldAmount, Result), T) :- 
    Name = greater_4_3_3,
    Result = Amount >= OldAmount, 
    occur(Action, (Agent, A, B, C, Amount), T), 
    hold(Fluent, (Agent, B, C, OldAmount), T), 
    require(Input),
    Input = (Agent, Action, Fluent),
    time(T). 
%
operation(Name, Input, (Amount, OldAmount, Result), T) :- 
    Name = greater_4_3_3,
    Result = Amount >= OldAmount, 
    occur(Action, (Agent, A, B, C, Amount), T), 
    hold(Fluent, (Agent, B, C, OldAmount), T), 
    require(Input),
    Input = (Agent, Action, Fluent),
    time(T). 

operation(Name, Input, (A, B, C, Amount), T) :- 
    Name = has_4_4_4,
    Result = Amount >= OldAmount, 
    occur(Action, (Agent, A, B, C, Amount), T), 
    hold(Fluent, (Agent, A, B, C, OldAmount), T), 
    require(Input),
    Input = (Agent, Action, Fluent, A, B),
    time(T). 

operation(Name, Input, (A, B, C, D, Amount), T) :- 
    Name = has_5_5_5,
    Result = Amount >= OldAmount, 
    occur(Action, (Agent, A, B, C, D, Amount), T), 
    hold(Fluent, (Agent, A, B, C, D, OldAmount), T), 
    require(Input),
    Input = (Agent, Action, Fluent, A, B),
    time(T). 

operation(Name, Input, (FromAgent, B, Item, Amount), T) :- 
    Name = has_4_4_4,
    Result = Amount >= OldAmount, 
    occur(Action, (Agent, FromAgent, B, Item, Amount), T), 
    hold(Fluent, (FromAgent, Agent, B, Item, OldAmount), T), 
    require(Input),
    Input = (Agent, Action, Fluent, FromAgent, Item),
    time(T). 

operation(Name, Input, (FromAgent, B, Item, Amount), T) :- 
    Name = has_4_4_4,
    Result = Amount >= OldAmount, 
    occur(Action, (Agent, FromAgent, B, Item, Amount), T), 
    hold(Fluent, (FromAgent, Agent, B, Item, OldAmount), T), 
    require(Input),
    Input = (Agent, Action, Fluent, FromAgent, Item),
    time(T). 

operation(Name, Input, (FromAgent, B, Item, Quality, Amount), T) :- 
    Name = has_5_5_5,
    Result = Amount >= OldAmount, 
    occur(Action, (Agent, FromAgent, B, Item, Quality, Amount), T), 
    hold(Fluent, (FromAgent, Agent, B, Item, Quality, OldAmount), T), 
    require(Input),
    Input = (Agent, Action, Fluent, FromAgent, Item, Quality),
    time(T). 


% executable LAWS
% cannot pay an amount more than available
% :- occur(<Agent>, pay, (Agent, Reason, Amount), T), paying_reason(<Agent>, Agent, Reason), hold(available_funds, (Fund), T), not Fund >= Amount.  % cannot deliver an amount more than available
% :- occur(<Agent>, deliver, (Agent, Item, Amount), T), deliver_item(<Agent>, Agent, Item), hold(available_item, (Item, CurrentAmount), T), not CurrentAmount >= Amount.
% :- occur(<Agent>, deliver_quality, (Agent, Item, Quality, Amount), T), deliver_item(<Agent>, Agent, Item, Quality), hold(available_item, (Item, CurrentAmount, Quality), T), not CurrentAmount >= Amount.
% % cannot deliver an item that is not a deliver item
% :- occur(<Agent>, deliver, (Agent, Item, Amount), T), not deliver_item(<Agent>, Agent, Item).
% :- occur(<Agent>, deliver_quality, (Agent, Item, Quality, Amount), T), not deliver_item(<Agent>, Agent, Item, Quality).
% % cannot receive item if there is no notification
% :- occur(<Agent>, receive, (Agent, TimeMark, Item, Amount), T), not hold(<TODO>, (Agent, TimeMark, Item, Amount), T). 
% :- occur(<Agent>, receive_quality, (Agent, TimeMark, Item, Quality, Amount), T), not hold(<TODO>, (Agent, TimeMark, Item, Quality, Amount), T). 
% % cannot receive item if it is not a recv_item
% :- occur(receive((Agent, TimeMark), Item, Amount), T), not recv_item(Agent, Item).
% :- occur(receive((Agent, TimeMark), Item, Amount, Quality), T), not recv_item(Agent, Item, Quality).
% % cannot receive money if there is no notification
% :- occur(receive_money(A, Reason, Amount), T), not hold(notification(A, payment, Reason, Amount), T). 
% % cannot receive money if the reason is not a receive reason 
% :- occur(receive_money((Agent, TimeMark), Reason, Amount), T), not receiving_reason(Agent, Reason). 
% % cannot produce an item that is not a produce item
% :- occur(produce(Item, Amount), T), not produce_item(Item). 