# we would expect that the output comes from running clingo with the flags -V0 --output-atoms=%s.
# on successful there will be an answer set
# also, there will be the word successful
# unhandled situations: atoms that do not occur in any rule head 
def parse_output(output: str): 
    output = output.strip()
    lines = output.split("\n")
    lines.pop(-1)
    return lines
