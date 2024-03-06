#script (python)
import random

N = clingo.Number
F = clingo.Function
def outcome(a):
    return N(a.number - random.randint(0, 100))

def success(a):
    answer = input(f"determine the success of {a.name}(y/n):")
    if answer == "y":
        return N(1)
    elif answer == "n":
        return N(0)
    
    if random.randint(0, 100) > 50:
        return N(1)
    return N(0)
#end.
occur_env_success(Ag, A, T) :- occur_env(Ag, A, T), current_time_env(T), 1==@success(A).