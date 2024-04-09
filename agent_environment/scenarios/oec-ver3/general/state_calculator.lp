% executability
possible(Action, Value, Time) :- executable(Agent, Action, Value, ConditionFluent), hold(ConditionFluent, (Agent, Action, Value, _), Time), type(ConditionFluent, parameterized), time(Time).
possible(Action, Value, Time) :- executable(Agent, Action, Value, ConditionFluent), hold(ConditionFluent, _, Time), not type(ConditionFluent, parameterized), time(Time).
possible(Action, Value, Time) :- not executable(Agent, Action, Value, _), action(Agent, Action, Value), time(Time). 
failed(Action, Value, Time) :- occur(Action, Value, Time), not possible(Action, Value, Time), time(Time).
% inputs
require(Operation, (Agent, Action, Value, Fluent, Input), T) :- causes(Agent, Action, Value, Fluent, Operation, Input), possible(Action, Value, T), occur(Action, Value, T), time(T).
require(Operation, Input, T) :- satisfy_condition(Agent, ConditionFluent, Operation, Input), time(T).
require(Operation, (Agent, TargetFluent, CausalFluent, Input), T) :- caused(Agent, TargetFluent, CausalFluent, Operation, Input), time(T).
% dynamic laws
hold(Fluent, Output, T+1) :- 
    causes(Agent, Action, Value, Fluent, Operation, Input), 
    occur(Action, Value, T),
    operation(Operation, (Agent, Action, Value, Fluent, Input), Output, T),
    possible(Action, Value, T),
    time(T+1). 
changed(Agent, action, Action, Fluent, Output, T) :- 
    causes(Agent, Action, Value, Fluent, Operation, Input), 
    occur(Action, Value, T),
    operation(Operation, (Agent, Action, Value, Fluent, Input), Output, T),
    possible(Action, Value, T),
    time(T+1). 
%
% static laws
hold(TargetFluent, TargetValue, T) :- 
    caused(Agent, TargetFluent, CausalFluent, Operation, Input), 
    hold(CausalFluent, CausalValue, T),
    operation(Operation, (Agent, TargetFluent, CausalFluent, Input), Output, T),
    Output=(CausalFluent, CausalValue, TargetFluent, TargetValue),
    time(T). 
changed(Agent, static, CausalFluent, TargetFluent, TargetValue, T) :- 
    caused(Agent, TargetFluent, CausalFluent, Operation, Input), 
    hold(CausalFluent, CausalValue, T),
    operation(Operation, (Agent, TargetFluent, CausalFluent, Input), Output, T),
    Output=(CausalFluent, CausalValue, TargetFluent, TargetValue),
    time(T). 
% static laws
hold(TargetFluent, TargetValue, T) :- 
    caused(Agent, TargetFluent, TargetValue, CausalFluent, CausalValue), 
    hold(TargetFluent, TargetValue, T),
    hold(CausalFluent, CausalValue, T),
    time(T).

changed(Agent, static, CausalFluent, TargetFluent, TargetValue, T) :- 
    caused(Agent, TargetFluent, TargetValue, CausalFluent, CausalValue), 
    hold(TargetFluent, TargetValue, T),
    hold(CausalFluent, CausalValue, T),
    time(T).
% condition sat 
hold(ConditionFluent, Input, T) :- 
    satisfy_condition(Agent, ConditionFluent, Operation, Input), 
    operation(Operation, Input, true, T),
    time(T). 
changed(Agent, satisfy, Input, ConditionFluent, true, T) :- 
    satisfy_condition(Agent, ConditionFluent, Operation, Input), 
    operation(Operation, Input, true, T),
    time(T). 
%
hold(ConditionFluent, Input, T) :- 
    satisfy_condition(Agent, ConditionFluent, Operation, Input), 
    operation(Operation, Input, true, T),
    time(T). 
changed(Agent, satisfy, Input, ConditionFluent, true, T) :- 
    satisfy_condition(Agent, ConditionFluent, Operation, Input), 
    operation(Operation, Input, true, T),
    time(T). 
% inertial laws
hold(Fluent, Value, T+1) :- hold(Fluent, Value, T), not changed(_, _, _, Fluent, _, T), not type(Fluent, parameterized), time(T+1).
hold(Fluent, (Agent, Value), T+1) :- 
    hold(Fluent, (Agent, Value), T), 
    not changed(Agent, _, _, Fluent, _, T), 
    type(Fluent, parameterized), time(T+1).
%
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