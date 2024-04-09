% executability
possible(Action, Value, Time) :- executable(Agent, Action, Value, ConditionFluent), hold(ConditionFluent, _, Time), time(Time).
possible(Action, Value, Time) :- not executable(Agent, Action, Value, _), action(Agent, Action, Value), time(Time). 
% inputs
require(Operation, Input, T) :- causes(Agent, Action, Value, Fluent, Operation, Input), possible(Action, Value, T), occur(Action, Value, T), time(T).
require(Operation, Input, T) :- satisfy_condition(Agent, ConditionFluent, Operation, Input), time(T).
require(Operation, Input, T) :- caused(Agent, TargetFluent, CausalFluent, Operation, Input), time(T).
% dynamic laws
hold(Fluent, Output, T+1) :- 
    causes(Agent, Action, Value, Fluent, Operation, Input), 
    occur(Action, Value, T),
    operation(Operation, Input, Output, T),
    possible(Action, Value, T),
    time(T+1). 
changed(action, Action, Fluent, Output, T) :- 
    causes(Agent, Action, Value, Fluent, Operation, Input), 
    occur(Action, Value, T),
    operation(Operation, Input, Output, T),
    possible(Action, Value, T),
    time(T+1). 
%
% static laws
hold(TargetFluent, TargetValue, T) :- 
    caused(Agent, TargetFluent, CausalFluent, Operation, Input), 
    hold(CausalFluent, CausalValue, T),
    operation(Operation, Input, Output, T),
    Output=(CausalFluent, CausalValue, TargetFluent, TargetValue),
    time(T). 
changed(static, CausalFluent, TargetFluent, TargetValue, T) :- 
    caused(Agent, TargetFluent, CausalFluent, Operation, Input), 
    hold(CausalFluent, CausalValue, T),
    operation(Operation, Input, Output, T),
    Output=(CausalFluent, CausalValue, TargetFluent, TargetValue),
    time(T). 
% static laws
hold(TargetFluent, TargetValue, T) :- 
    caused(Agent, TargetFluent, TargetValue, CausalFluent, CausalValue), 
    hold(TargetFluent, TargetValue, T),
    hold(CausalFluent, CausalValue, T),
    time(T).

changed(static, CausalFluent, TargetFluent, TargetValue, T) :- 
    caused(Agent, TargetFluent, TargetValue, CausalFluent, CausalValue), 
    hold(TargetFluent, TargetValue, T),
    hold(CausalFluent, CausalValue, T),
    time(T).
% condition sat 
hold(ConditionFluent, Input, T) :- 
    satisfy_condition(Agent, ConditionFluent, Operation, Input), 
    operation(Operation, Input, true, T),
    time(T). 
changed(satisfy, Input, ConditionFluent, true, T) :- 
    satisfy_condition(Agent, ConditionFluent, Operation, Input), 
    operation(Operation, Input, true, T),
    time(T). 
%
hold(ConditionFluent, Input, T) :- 
    satisfy_condition(Agent, ConditionFluent, Operation, Input), 
    operation(Operation, Input, true, T),
    time(T). 
changed(satisfy, Input, ConditionFluent, true, T) :- 
    satisfy_condition(Agent, ConditionFluent, Operation, Input), 
    operation(Operation, Input, true, T),
    time(T). 
% inertial laws
hold(Fluent, Value, T+1) :- hold(Fluent, Value, T), not changed(_, _, Fluent, _, T), not type(Fluent, parameterized), time(T+1).
hold(Fluent, (Agent, Value), T+1) :- 
    hold(Fluent, (Agent, Value), T), 
    not changed(_, _, Fluent, _, T), 
    type(Fluent, parameterized), time(T+1).
hold(Fluent, (Agent, Value), T+1) :- 
    hold(Fluent, (Agent, Value), T), 
    inertial(Agent, Fluent, Operation, Input),
    operation(Operation, (Agent, Fluent, Value, NewChanges, Input), true, T),
    changed(_, _, Fluent, NewChanges, T), 
    type(Fluent, parameterized), time(T+1).

require(Operation ,(Agent, Fluent, Value, NewChanges, Input), T) :-
    inertial(Agent, Fluent, Operation, Input),
    hold(Fluent, (Agent, Value), T), 
    changed(_, _, Fluent, NewChanges, T), 
    type(Fluent, parameterized), time(T+1).