% test case 11 -  test constraints, only action can occur at one time
% expect unsatisfaction 
time(0..2).
produce_item(apple).
hold(available_item(apple, 0), 0).
occur(produce(apple, 1000), 0).
occur(produce(apple, 2000), 0).