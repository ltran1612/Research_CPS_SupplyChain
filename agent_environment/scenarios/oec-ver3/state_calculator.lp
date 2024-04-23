% skeptical state calculation for a time T+1.
% calcualte state at time T+1 from time T. 
% if there is a conflict, all actions at T automatically fail, all fluent literals are transfered from T to T+1.
% assumes that one action occur at one time.
%
% executability
possible(Action, (Agent, Value), Time) :- executable(Agent, Action, Value, ConditionFluent), hold(ConditionFluent, (Agent, (Action, Value, _)), Time), type(ConditionFluent, agent), time(Time).
possible(Action, (Agent, Value), Time) :- executable(Agent, Action, Value, ConditionFluent), hold(ConditionFluent, _, Time), not type(ConditionFluent, agent), time(Time).
possible(Action, (Agent, Value), Time) :- not executable(Agent, Action, Value, _), action(Agent, Action, Value), time(Time). 
failed(Action, Value, Time) :- occur(Action, Value, Time), not possible(Action, Value, Time), time(Time).
% inputs
require(Operation, (Agent, Action, Value, Fluent, Input), T) :- causes(Agent, Action, Value, Fluent, Operation, Input), possible(Action, (Agent, Value), T), occur(Action, (Agent, Value), T), time(T).
require(Operation, (Agent, Input), T) :- satisfy_condition(Agent, ConditionFluent, Operation, Input), time(T).
require(Operation, (Agent, TargetFluent, CausalFluent, CausalValue, Input), T) :- 
    hold(CausalFluent, CausalValue, T),
    caused(Agent, op, TargetFluent, CausalFluent, Operation, Input), time(T).
% dynamic laws
hold_attempt(Fluent, Output, T+1) :- 
    causes(Agent, Action, Value, Fluent, Operation, Input), 
    occur(Action, (Agent, Value), T),
    operation(Operation, (Agent, Action, Value, Fluent, Input), Output, T),
    possible(Action, (Agent, Value), T),
    time(T+1). 
changed(Agent, action, Action, Fluent, Output, T) :- 
    causes(Agent, Action, Value, Fluent, Operation, Input), 
    occur(Action, (Agent, Value), T),
    operation(Operation, (Agent, Action, Value, Fluent, Input), Output, T),
    possible(Action, (Agent, Value), T),
    not failed(T+1),
    time(T+1). 
%
% static laws
hold_attempt(TargetFluent, Output, T) :- 
    caused(Agent, op, TargetFluent, CausalFluent, Operation, Input), 
    operation(Operation, (Agent, TargetFluent, CausalFluent, CausalValue, Input), Output, T),
    time(T). 
changed(Agent, static, CausalFluent, TargetFluent, Output, T) :- 
    caused(Agent, op, TargetFluent, CausalFluent, Operation, Input), 
    operation(Operation, (Agent, TargetFluent, CausalFluent, CausalValue, Input), Output, T),
    not failed(T),
    time(T). 

% static laws
hold_attempt(TargetFluent, TargetValue, T) :- 
    caused(Agent, TargetFluent, TargetValue, CausalFluent, CausalValue), 
    hold(CausalFluent, CausalValue, T),
    time(T).
changed(Agent, static, CausalFluent, TargetFluent, TargetValue, T) :- 
    caused(Agent, TargetFluent, TargetValue, CausalFluent, CausalValue), 
    hold(CausalFluent, CausalValue, T),
    not failed(T),
    time(T).
% condition sat 
hold_attempt(ConditionFluent, Input, T) :- 
    satisfy_condition(Agent, ConditionFluent, Operation, Input), 
    operation(Operation, (Agent, Input), true, T),
    not type(ConditionFluent, agent),
    time(T). 
changed(Agent, satisfy, Input, ConditionFluent, true, T) :- 
    satisfy_condition(Agent, ConditionFluent, Operation, Input), 
    operation(Operation, (Agent, Input), true, T),
    not type(ConditionFluent, agent),
    not failed(T),
    time(T). 
% agent type fluents
hold_attempt(ConditionFluent, (Agent, Input), T) :- 
    satisfy_condition(Agent, ConditionFluent, Operation, Input), 
    operation(Operation, (Agent, Input), true, T),
    type(ConditionFluent, agent),
    time(T). 
changed(Agent, satisfy, (Agent, Input), ConditionFluent, true, T) :- 
    satisfy_condition(Agent, ConditionFluent, Operation, Input), 
    operation(Operation, (Agent, Input), true, T),
    type(ConditionFluent, agent),
    not failed(T),
    time(T). 
% implement conjunction
hold(Parent, (), T) :- fluent(Parent), 
    type(Parent, conjunction), 
    not type(Parent, agent), 
    A=#count{O: member(O, Parent)}, 
    B=#count{O: member(Agent, O, Parent)}, 
    C=#count{O: hold(O, _, T), member(O, Parent), not type(O, agent)}, 
    D=#count{O: hold(O, (Agent, _), T), member(Agent, O, Parent), type(O, agent)}, 
    A+B = C+D,
    time(T). 
% implement conjunction
hold(Parent, (), T) :- fluent(Parent), 
    type(Parent, conjunction), 
    not type(Parent, agent), 
    A=#count{O: member(O, Parent)}, 
    B=#count{O: member(Agent, O, Parent)}, 
    C=#count{O: hold(O, _, T), member(O, Parent), not type(O, agent)}, 
    D=#count{O: hold(O, (Agent, _), T), member(Agent, O, Parent), type(O, agent)}, 
    A+B = C+D,
    time(T). 
% inertial laws
hold(Fluent, Value, T+1) :- hold(Fluent, Value, T), 
    not changed(_, action, _, Fluent, _, T),
    not changed(_, static, _, Fluent, _, T+1), 
    not changed(_, satisfy, _, Fluent, _, T+1), 
    not type(Fluent, agent), 
    not type(Fluent, conjunction), 
    time(T+1).
% agent type fluents
hold(Fluent, (Agent, Value), T+1) :- hold(Fluent, (Agent, Value), T), 
    not changed(Agent, action, _, Fluent, _, T), 
    not changed(Agent, static, _, Fluent, _, T+1), 
    not changed(Agent, satisfy, _, Fluent, _, T+1), 
    type(Fluent, agent), time(T+1).
% intertial for the fluents of an agent that differs by some parts in its vallues.
% for example, hold(f, (quality1, Amount)) and hold(f, (quality2, Amount)) are different.
% changes in quality1 should not affect quality2. 
hold(Fluent, (Agent, Value), T+1) :- 
    hold(Fluent, (Agent, Value), T), 
    inertial(Agent, Fluent, Operation, Input),
    operation(Operation, (Agent, Fluent, (Agent, Value), NewChanges, Input), true, T),
    changed(Agent, action, _, Fluent, NewChanges, T), 
    type(Fluent, agent), time(T+1).
require(Operation ,(Agent, Fluent, (Agent, Value), NewChanges, Input), T) :-
    inertial(Agent, Fluent, Operation, Input),
    hold(Fluent, (Agent, Value), T), 
    changed(Agent, action, _, Fluent, NewChanges, T), 
    type(Fluent, agent), time(T+1).
%
causal_type(static).
causal_type(satisfy).
hold(Fluent, (Agent, Value), T+1) :- 
    hold(Fluent, (Agent, Value), T), 
    inertial(Agent, Fluent, Operation, Input),
    operation(Operation, (Agent, Fluent, (Agent, Value), NewChanges, Input), true, T),
    changed(Agent, Type, _, Fluent, NewChanges, T+1), 
    causal_type(Type),
    type(Fluent, agent), time(T+1).
require(Operation ,(Agent, Fluent, (Agent, Value), NewChanges, Input), T) :-
    inertial(Agent, Fluent, Operation, Input),
    hold(Fluent, (Agent, Value), T), 
    changed(Agent, Type, _, Fluent, NewChanges, T+1), 
    causal_type(Type),
    type(Fluent, agent), time(T+1).

% a fluent cannot be both conjunction and agent 
:- type(F, conjunction), type(F, agent). 
% cannot have a normal member that is agent
:- member(F, Parent), type(F, agent). 
:- member(Agent, F, Parent), not type(F, agent). 
% resolve skeptical state calculation
failed(F, T) :- hold_attempt(F, V1, T), hold_attempt(F, V2, T), not type(F, agent), V1 != V2.
hold(F, V, T) :- hold_attempt(F, V, T), not failed(F, T).
% constraints for fluents to satisfy the static causal law 
:- not type(F, agent), hold(F, A, T), hold(F, B, T), not A = B. 
% if one fluent failed, the entire actions occur in this T failed. 
failed(T) :- failed(F, T).
failed(Action, Value, Time) :- occur(Action, Value, Time), failed(Time).