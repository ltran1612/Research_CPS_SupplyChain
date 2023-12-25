import re

def get_param_nums(string: str):
    count = 0
    level = 0
    for c in string:
        if c == "," and level == 1:
            count += 1
        elif c == "(":
            level += 1
        elif c == ")":
            level -= 1
    
    return count + 1

class ParserFactory:
    function_name = re.compile(f"_*[a-z][A-Za-z0-9_']*") 

    def __init__(self, fluent="fluent", action="action", hold="hold") -> None:
       self.fluent_str = fluent 
       self.action_str = action 
       self.hold_str = hold 

    def is_fluent(self, fluent):
        return self.fluent_str in fluent 
        
    # return a parser for fluent
    def fluent(self):
        def parser(fluent):
            temp = fluent 
            # remove the last ")."
            temp = temp[:-2]
            # remove the fluent predicate's name
            temp = temp[len(self.fluent_str):]

            # search for function name
            name = re.search(self.function_name, temp).group(0)
            parameters = temp[len(name):]
            param_num = get_param_nums(parameters)
            return (name, param_num)

        return parser

    # return a parser for action 
    def action(self):
        def parser(action):
            temp = action 
            # remove the last ")."
            temp = temp[:-2]
            # remove the action predicate's name
            temp = temp[len(self.action_str):]

            # search for function name
            name = re.search(self.function_name, temp).group(0)
            parameters = temp[len(name):]
            param_num = get_param_nums(parameters)
            return (name, param_num)

        return parser
