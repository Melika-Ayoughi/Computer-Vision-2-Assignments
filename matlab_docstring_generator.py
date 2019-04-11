
import os
import sys
from difflib import SequenceMatcher
import numpy as np

def get_docstring(function_name, inputs, outputs):
    output = []
    output.append(f" % {function_name.upper()}\t\t [add function description here]\n")
    output.append(f" % INPUTS \n")
    for inp in inputs:
        output.append(f" %\t\t\t{inp} = ..\n")
    output.append(f" % OUTPUTS \n")
    for outp in outputs:
        output.append(f" %\t\t\t{outp} = ..\n")
    output.append("\n\n")
    return output

def convert_file(name):

    f  =open(name, "r")

    file_content = []

    first_line = ""

    for i, line in enumerate(f):

        if (i == 0):
            if (not "% DOCSTRING_GENERATED" in line and "function" in line ):

                first_line = line
                outputs = []
                inputs = []

                function_name = line.split("(")[0].split("=")[-1].split(" ")[-1]

                if ("=" in line):

                    splitted = line.split("=")
                    outputs = splitted[0].replace("function", "").replace(" ", "").replace("[", "").replace("]", "").split(",")

                if (not "()" in line):

                    inputs = line.split("(")[-1].split(")")[0].replace(" ", "").split(",")

                file_content.append(line.replace("\n", "") + "\t % DOCSTRING_GENERATED\n")
                docstring = get_docstring(function_name, inputs, outputs)
                for element in docstring:
                    file_content.append(element)
                continue
            else:
                return

        file_content.append(line)

    f.close()

    g = open(name, "w")

    for newline in file_content:
        g.write(newline)

    g.close()

path = ""
stack = ["."]

while(len(stack) > 0):

    path = stack.pop()

    # path_current = os.path.join(path, current)

    for entry in os.listdir(path):
        if os.path.isdir(os.path.join(path, entry)):
            stack.append(os.path.join(path, entry))
        elif (entry.endswith(".m")):
            convert_file(os.path.join(path, entry))
        else:
            continue




