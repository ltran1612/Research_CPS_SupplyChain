% EXPRESS THE ENTIRE ACTION LANGUAGE AS ATOMS - META ENCODINGS
% BASED ON ANSWER SET PROGRAMMING SURVEY PAPER - BASED ON META ENCODINGS
% A user only needs to care about:
% - normal_fluent
% - exogenous_fluent 
% - conjunction_fluent 
% - atomic_condition_fluent 
% - condition
% - action
% - causes
% - caused
% - operation
% - boolean_operation
%
% ASSUMPTIONS:
% 1. Each fluent name can only have one type of value. 
% 2. If a fluent is not in the answer for a time T (there is no hold(F, Value, T), the fluent is false in time T.

% hold/occur forms:
% - Individual form: hold(F, T), occur(A, T). 
% - Global form: hold(Agent, F, T), occur(Agent, A, T). 

% OPERATIONS
% ARBITRARY OPERATIONS 
% Define Arbitrary Operations with: 
% - operation(OperationName, Input, Output) :- input((Input)), Output=<...>.
% BOOLEAN OPERATIONS
% - boolean_operation(OperationName, Input, Output) :- input((Input)), Output=true|false.
% Operations should be defined to use the global form of hold/occur.

% The following rules work only with global form. To use this one with local forms. map your individual form hold/occur to global form hold/occur. 
% Also, convert the laws form to global form.
% FLUENTS
% A fluent will have a name and its value.
% Define fluents with:
% - normal_fluent(FluentName, arity): fluent that is not a condition and its value has 2 arguments.
% - exogenous_fluent(FluentName, Agent): fluent that is exogenous from Agent agent.
% - conjunction_fluent(FluentName): a conjunction condition fluent.
% - atomic_condition_fluent(FluentName): an atomic condition.
% - condition_fluent(Fluent): a condition fluent.
%
% CONDITIONS
% A condition fluent will have a value. However, its value is given to the operation. It is not a determination of the satisfiability of the condition. 
% Define the satisfiability of atomic condition fluent as follows:
% - satisfy_atomic(AtomicFluentName, Input, BooleanOperationName, ExtraInfo): the operation that will be performed to determine the success of the atomic condition.

% ACTUAL RULES TO ENFORCE FLUENTS AND CONDITIONS 
% FLUENTS 
fluent(FluentName) :- normal_fluent(FluentName, _).
fluent(FluentName) :- exogenous_fluent(FluentName, _).
fluent(FluentName) :- condition_fluent(FluentName).
%
:- normal_fluent(FluentName1, _), exogenous_fluent(FluentName2, _), not FluentName1!=FluentName2.  
 
:- normal_fluent(FluentName1, _), condition_fluent(FluentName1), not FluentName1!=FluentName2.  
:- condition_fluent(FluentName1), exogenous_fluent(FluentName2, _), not FluentName1!=FluentName2. 
% CONDITIONS 
condition_fluent(FluentName) :- conjunction_fluent(FluentName).
condition_fluent(FluentName) :- atomic_condition_fluent(FluentName).
% RULES FOR SATISFACTION OF CONDITIONS
:- satisfy_atomic(AtomicFluentName, Input, BooleanOperationName, ExtraInfo), not atomic_condition_fluent(AtomicFluentName).
% 
:- conjunction_fluent(FluentName), not atomic_condition_fluent(FluentName).
%
input((Input, ExtraInfo)) :- 
    satisfy_atomic(AtomicFluentName, Input, BooleanOperationName, ExtraInfo),
    atomic_condition_fluent(AtomicFluentName),
    time(Time).
%
hold(AtomicFluentName, (), Time) :- 
    satisfy_atomic(AtomicFluentName, Input, BooleanOperationName, ExtraInfo),
    atomic_condition_fluent(AtomicFluentName),
    boolean_operation(BooleanOperationName, (Input, ExtraInfo), true),
    time(Time).

condition_fluent("").
hold("", (), T) :- time(T).

% The fluents and actions will has these forms in the answer set:
% - Fluent: hold(FluentName, Value, Time).
% - Action: occur(ActionName, Value, Time).
%
% Define conjunction conditions as:
% - member(ConditionFluent, ConjunctionConditionFluent):
% -- ConditionFluent: the name of the member condition fluent.
% -- ConjunctionConditionFluent: the name of the result condition fluent.
%
% ACTIONS 
% Define actions as:
% action(ActionName, Value) 
%
% DYNAMIC LAWS
% Define dynamic laws with: 
% - causes(ActionName, ActionTargetFluent, OperationName, FluentConditionName, ExtraInfo) 
% -- ActionName: the name of the action that causes the change.
% -- ActionTargetFluentName: the name of the fluent that will be changed.
% -- OperationgName: the operation that will be performed to calculate the changes of the fluent.
% -- FluentConditionName: The name of the fluent condition for the action to take effect. 
% -- ExtraInfo: any extra information to give to the operation
%
% EXECUTABILITY LAWS
% Definte executability laws with:
% - executable(ActionName, FluentConditionName).  
% -- ActionName: the name of the action that is executable.
% -- FluentConditionName: the name of the fluent condition that needs to be true for the action to be executable.
%
% STATIC CAUSAL LAWS
% Definte static causal laws with:
% caused(AffectedFluentName, CausalFluentName, AffectedFluentNewValue, CausalFluentValue, ExtraInfo).
% caused(AffectedFluentName, CausalFluentName, OperationName, ExtraInfo).

% RULES TO DETERMINE THE VALUE OF FLUENTS
% Fluent condition has to be a condition fluent.
:- causes(_, _, _, FluentConditionName, _), not condition_fluent(FluentConditionName).
:- executable(ActionName, FluentConditionName), not condition_fluent(FluentConditionName).

% conditions satisfaction 
hold(Condition, (), T) :- conjunction_fluent(Condition), 
    M=#count{MemberCondition: member(MemberCondition, Condition), condition_fluent(MemberCondition)},
    MS=#count{MemberCondition: member(MemberCondition, Condition), condition_fluent(MemberCondition), hold(MemberCondition, _, T)},
    time(T).

% dynamic laws + executability laws
% executability law
possible(ActionName, Time) :- causes(ActionName, _, _, _, _), 
    not executable(ActionName, _), 
    time(Time).

possible(ActionName, Time) :- causes(ActionName, _, _, _, _), 
    executable(ActionName, FluentConditionName), 
    hold(FluentConditionName2, ConditionValue2, Time),
    time(Time).

% dynamic laws
input((ActionValue, FluentValue, ExtraInfo)) :- 
    % dynamic law
    causes(ActionName, ActionTargetFluentName, OperationName, FluentConditionName, ExtraInfo), 
    condition_fluent(FluentConditionName), 
    hold(FluentConditionName, _, Time), 
    %
    possible(ActionName, Time),
    % action occur
    hold(ActionTargetFluentName, FluentValue, Time), 
    occur(ActionName, ActionValue, Time), 
    % conditions
    time(Time). 
% 
changed_by_dynamic(ActionTargetFluentName, NewValue, Time) :- 
    % dynamic law
    causes(ActionName, ActionTargetFluentName, OperationName, FluentConditionName, ExtraInfo), 
    condition_fluent(FluentConditionName), 
    hold(FluentConditionName, _, Time), 
    %
    possible(ActionName, Time),
    % action occur
    hold(ActionTargetFluentName, FluentValue, Time), 
    occur(ActionName, ActionValue, Time), 
    % operation
    operation(OperationName, (ActionValue, FluentValue, ExtraInfo), NewValue),
    %
    time(Time).
%
hold(ActionTargetFluentName, NewValue, Time+1) :- 
    changed_by_dynamic(ActionTargetFluentName, NewValue, Time),
    time(Time+1).

% static causal laws
% form 1
%
changed_by_causal(AffectedFluentName, AffectedFluentNewValue, Time) :-
    caused(AffectedFluentName, CausalFluentName, AffectedFluentNewValue, CausalFluentValue, ExtraInfo), 
    hold(CausalFluentName, CausalFluentValue, Time),
    time(Time).
% form 2
input((CausalValue, ExtraInfo)) :- 
    caused(AffectedFluentName, CausalFluentName, OperationName, ExtraInfo),
    hold(CausalFluentName, CausalValue, Time),
    time(Time).
%
changed_by_causal(AffectedFluentName, NewValue, Time) :-
    caused(AffectedFluentName, CausalFluentName, OperationName, ExtraInfo),
    hold(CausalFluentName, CausalValue, Time),
    operation(OperationName, (CausalValue, ExtraInfo), NewValue), 
    time(Time).
% actual effect of static causal laws
hold(AffectedFluentName, NewValue, Time) :- changed_by_causal(AffectedFluentName, NewValue, Time).

% inertial laws
hold(FluentName, OldValue, Time+1) :- hold(FluentName, OldValue, Time), 
    not changed_by_causal(FluentName, _, Time), 
    not changed_by_dynamic(FluentName, _, Time),
    time(Time+1).
