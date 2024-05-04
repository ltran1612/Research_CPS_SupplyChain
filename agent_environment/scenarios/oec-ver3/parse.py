import re
import sys
def replace(content: str, replacement):
    return content.replace("<Agent>", replacement).replace("<todo>", "()")

if __name__ == '__main__':
    agent = "default"
    file = sys.argv[1]
    if len(sys.argv) > 2: 
        agent = sys.argv[2]
    content = ""
    with open(file, 'r') as f:
        content = "".join(f.readlines())
        content = replace(content, agent)
    with open("a.out", "w") as f:
        f.write(content)