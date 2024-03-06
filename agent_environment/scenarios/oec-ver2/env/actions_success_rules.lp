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
occur_env_attempt_success(Ag, A, T) :- occur_env_attempt(Ag, A, T), 1==@success(A).