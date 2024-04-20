% executability
possible(Action, (Agent, Value), Time) :- executable(Agent, Action, Value, ConditionFluent), hold(ConditionFluent, (Agent, (Action, Value, _)), Time), type(ConditionFluent, parameterized), time(Time).
possible(Action, (Agent, Value), Time) :- executable(Agent, Action, Value, ConditionFluent), hold(ConditionFluent, _, Time), not type(ConditionFluent, parameterized), time(Time).
possible(Action, (Agent, Value), Time) :- not executable(Agent, Action, Value, _), action(Agent, Action, Value), time(Time). 
failed(Action, Value, Time) :- occur(Action, Value, Time), not possible(Action, Value, Time), time(Time).
% inputs
require(Operation, (Agent, Action, Value, Fluent, Input), T) :- causes(Agent, Action, Value, Fluent, Operation, Input), possible(Action, (Agent, Value), T), occur(Action, (Agent, Value), T), time(T).
require(Operation, (Agent, Input), T) :- satisfy_condition(Agent, ConditionFluent, Operation, Input), time(T).
require(Operation, (Agent, TargetFluent, CausalFluent, CausalValue, Input), T) :- 
    hold(CausalFluent, CausalValue, T),
    caused(Agent, TargetFluent, CausalFluent, Operation, Input), time(T).
% dynamic laws
hold(Fluent, Output, T+1) :- 
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
    time(T+1). 
%
% static laws
hold(TargetFluent, Output, T) :- 
    caused(Agent, TargetFluent, CausalFluent, Operation, Input), 
    operation(Operation, (Agent, TargetFluent, CausalFluent, CausalValue, Input), Output, T),
    time(T). 
changed(Agent, static, CausalFluent, TargetFluent, Output, T) :- 
    caused(Agent, TargetFluent, CausalFluent, Operation, Input), 
    operation(Operation, (Agent, TargetFluent, CausalFluent, CausalValue, Input), Output, T),
    time(T). 

% static laws
hold(TargetFluent, TargetValue, T) :- 
    caused(Agent, TargetFluent, TargetValue, CausalFluent, CausalValue), 
    hold(CausalFluent, CausalValue, T),
    time(T).
changed(Agent, static, CausalFluent, TargetFluent, TargetValue, T) :- 
    caused(Agent, TargetFluent, TargetValue, CausalFluent, CausalValue), 
    hold(CausalFluent, CausalValue, T),
    time(T).
% condition sat 
hold(ConditionFluent, Input, T) :- 
    satisfy_condition(Agent, ConditionFluent, Operation, Input), 
    operation(Operation, (Agent, Input), true, T),
    not type(ConditionFluent, parameterized),
    time(T). 
changed(Agent, satisfy, Input, ConditionFluent, true, T) :- 
    satisfy_condition(Agent, ConditionFluent, Operation, Input), 
    operation(Operation, (Agent, Input), true, T),
    not type(ConditionFluent, parameterized),
    time(T). 
%
hold(ConditionFluent, (Agent, Input), T) :- 
    satisfy_condition(Agent, ConditionFluent, Operation, Input), 
    operation(Operation, (Agent, Input), true, T),
    type(ConditionFluent, parameterized),
    time(T). 
changed(Agent, satisfy, (Agent, Input), ConditionFluent, true, T) :- 
    satisfy_condition(Agent, ConditionFluent, Operation, Input), 
    operation(Operation, (Agent, Input), true, T),
    type(ConditionFluent, parameterized),
    time(T). 
% inertial laws
hold(Fluent, Value, T+1) :- hold(Fluent, Value, T), not changed(_, _, _, Fluent, _, T), not type(Fluent, parameterized), time(T+1).
hold(Fluent, (Agent, Value), T+1) :- 
    hold(Fluent, (Agent, Value), T), 
    not changed(Agent, _, _, Fluent, _, T), 
    type(Fluent, parameterized), time(T+1).
% intertial for the paramterized fluents of an agent that differs by some parts in its vallues.
% for example, hold(f, (quality1, Amount)) and hold(f, (quality2, Amount)) are different.
% changes in quality1 should not affect quality2. 
hold(Fluent, (Agent, Value), T+1) :- 
    hold(Fluent, (Agent, Value), T), 
    inertial(Agent, Fluent, Operation, Input),
    operation(Operation, (Agent, Fluent, (Agent, Value), NewChanges, Input), true, T),
    changed(Agent, _, _, Fluent, NewChanges, T), 
    type(Fluent, parameterized), time(T+1).
require(Operation ,(Agent, Fluent, (Agent, Value), NewChanges, Input), T) :-
    inertial(Agent, Fluent, Operation, Input),
    hold(Fluent, (Agent, Value), T), 
    changed(Agent, _, _, Fluent, NewChanges, T), 
    type(Fluent, parameterized), time(T+1).

% implement conjunction
hold(Parent, (), T) :- fluent(Parent), 
    type(Parent, conjunction), 
    not type(Parent, parameterized), 
    A=#count{O: member(O, Parent)}, 
    B=#count{O: member(Agent, O, Parent)}, 
    C=#count{O: hold(O, _, T), member(O, Parent), not type(O, parameterized)}, 
    D=#count{O: hold(O, (Agent, _), T), member(Agent, O, Parent), type(O, parameterized)}, 
    A+B = C+D,
    time(T). 

% a fluent cannot be both conjunction and parameterized 
:- type(F, conjunction), type(F, parameterized). 
% cannot have a normal member that is parameterized
:- member(F, Parent), type(F, parameterized). 
:- member(Agent, F, Parent), not type(F, parameterized). 
% a parameterized fluent needs an intertial  
%
