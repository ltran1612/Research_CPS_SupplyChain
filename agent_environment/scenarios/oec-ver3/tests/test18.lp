% test traditional cps ontology reasoning
% expect satisfaction
% :- not h(sat("cpsf:received_on_schedule"), _).
#show h/2.
% % obs(sat("cpsf:received_on_schedule"),true).
:- not h(sat("cpsf:Functionality"), 4..10).
:- h(sat("cpsf:Functionality"), 0..3).
% PXK1 = {C1: received-on-schedule, C3: on-time-payment} 
addressedBy("cpsf:Received_On_Schedule", "C2").
%%CONTRACT%%%
% clauses id 
% clauses for car producer
% in this form, we assuem that each time() represents a day
clause("C2").
% C2: A responsible_for delivered(vehicle_parts, 9K) when by_week 4
hold(sat("C2"), T) :-  hold(total_received, (test, (agent2, receiving_item, 101)), 4), step(T), T >= 4. 
% expect satisfaction
% test state
time(0..10).
hold(available_item, (test, (receiving_item, 0)), 0).
hold(total_received, (test, (agent1, receiving_item, 0)), 0).
hold(total_received, (test, (agent2, receiving_item, 0)), 0).
pay_item(agent1, test, receiving_item).
recv_item(test, agent1, receiving_item).
recv_item(test, agent2, receiving_item).
number(50).
number(101).
% test condition
% test dynamic law 
% receive money 1
hold(delivered, (agent1, (test, 1, receiving_item, 50)), 1). 
occur(receive, (test, (agent1, 1, receiving_item, 50)), 1).
:- not action(test, receive, (agent1, 1, receiving_item, 50)).
:- not hold(available_item, (test, (receiving_item, 0)), 0..1).
:- not hold(available_item, (test, (receiving_item, 50)), 2).
:- not hold(total_received, (test, (agent1, receiving_item, 0)), 1).
:- not hold(total_received, (test, (agent1, receiving_item, 50)), 2).
% receive money 2 (with a gap from 1) 
hold(delivered, (agent2, (test, 2, receiving_item, 101)), 3). 
occur(receive, (test, (agent2, 2, receiving_item, 101)), 3).
:- not action(test, receive, (agent2, 2, receiving_item, 101)).
:- not hold(available_item, (test, (receiving_item, 50)), 3).
:- not hold(available_item, (test, (receiving_item, 151)), 4).
:- not hold(total_received, (test, (agent2, receiving_item, 0)), 3).
:- not hold(total_received, (test, (agent2, receiving_item, 101)), 4).

% receive money 3 (continuation of 2)
hold(delivered, (agent1, (test, 3, receiving_item, 102)), 5). 
occur(receive, (test, (agent1, 3, receiving_item, 102)), 5).
:- not action(test, receive, (agent2, 2, receiving_item, 101)).
:- not hold(available_item, (test, (receiving_item, 151)), 5).
:- not hold(available_item, (test, (receiving_item, 253)), 6).
:- not hold(total_received, (test, (agent1, receiving_item, 50)), 5).
:- not hold(total_received, (test, (agent1, receiving_item, 152)), 6).

% % edge case
:- hold(available_item, (test, (receiving_item, _)), 11).

% % no same signature
% % test intertial rules
:- hold(available_item, (test, (receiving_item, 151)), 6..10).
:- not hold(available_item, (test, (receiving_item, 253)), 6..10).
:- not hold(total_received, (test, (agent1, receiving_item, 152)), 6..10).
:- not hold(total_received, (test, (agent2, receiving_item, 101)), 6..10).