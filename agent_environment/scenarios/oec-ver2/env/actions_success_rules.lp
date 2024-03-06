#script (python)
import random
import clingo

N = clingo.Number
F = clingo.Function
def outcome(a):
    return N(a.number - random.randint(0, 100))

def success(a):
    if random.randint(0, 100) > 50:
        return N(1)
    return N(0)
#end.
occur_env_success(Ag, A, T) :- occur_env(Ag, A, T), current_time_env(T), 1==@success(A).