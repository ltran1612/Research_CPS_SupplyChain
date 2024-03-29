% test 6 - test notifications with no quality - error case - cannot  receive from a notification that was not specified to be a a receiving item
% expect unsatisfaction
% test state
time(0..10).

% test condition
% test dynamic law 
% receive money 1
hold(notification((agent1, 1), receiving_item, 50), 1). 
occur(receive((agent1, 1), receiving_item, 50), 1).