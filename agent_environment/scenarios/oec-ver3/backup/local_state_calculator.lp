% convert the fluents into a global state
hold(A, F, V, T) :- hold(F, V, T), agent_id(A).
hold(F, V, T) :- hold(A, F, V, T), agent_id(A).
occur(Ag, A, V, T) :- occur(A, V, T), agent_id(Ag).
occur(A, V, T) :- occur(Ag, A, V, T), agent_id(Ag).

% only one action for a time period
:- not 1>=#count{(Action, Value) : occur(Action, Value, Time), time(Time)}. 

% dynamic law 
hold(TargetFluent, FluentValue, Time+1) :- 
    occur(Action, Value, Time),
    dynamic_law(Action, TargetFluent, Operation, Condition),
    operation(_, Operation, (dynamic, Action, Value, TargetFluent), FluentValue, Time),
    hold(Condition, _, Time). 

% executability law
possible(Action, Time) :- 
    executability_law(Action, Condition), 
    hold(Condition, _, Time).
:- occur(Action, ActionValue, Time), executability_law(Action, Condition), not possible(Action, ActionValue, Time).

% static causal law
hold(AffectedFluentName, AffectedFluentNewValue, Time) :-
    static_causal_law(AffectedFluentName, AffectedFluentNewValue, CausalFluentName, CausalFluentValue),
    hold(CausalFluentName, CausalFluentValue, Time).
hold(AffectedFluentName, NewValue, Time) :- 
    static_causal_law(AffectedFluentName, CausalFluentName, OperationName),
    operation(_, OperationgName, (static, CausalFluentName, AffectedFluentName), NewValue, Time).

% conditions
% member(Conjunction, Condition).
hold(AtomicFluentConditionName, (), Time) :- 
    satisfy(AtomicFluentConditionName, BooleanOperationName),
    operation(BooleanOperationName, (AtomicFluentConditionName), true, Time). 

% conjunction
hold(Conjunction, (), Time) :- 
    Total=#count{Condition: member(Conjunction, Condition)},
    Count=#count{Condition: member(Conjunction, Condition), hold(Condition, _, Time)},
    fluent(Conjunction),
    fluent_type(Conjunction, conjunction),
    Total=Count,
    time(Time).
