import os
import torch


device = torch.device('cuda' if torch.cuda.is_available() else 'cpu')

def ensure_current_directory():

    current_dir = os.getcwd()
    os.chdir(current_dir.split("Assignment_3")[0] + "Assignment_3/")


def create_mask(commands, dim=0):
    output = []
    for command in commands:
        if (command == 1):
            output.append(torch.ones(1))
        else:
            output.append(torch.zeros(1))
    return torch.stack(output, dim=dim)


def torchify_2(matr, x):
    masks = {i: create_mask([j == i for j in range(x)], dim=1) for i in range(x)}

    rows = {}

    for i, row in enumerate(matr):

        columns = {}

        for j, column in enumerate(row):
            columns[j] = column*masks[j]

        rows[i] = sum(tuple(columns[k] for k in columns))

    result = torch.cat(tuple(rows[k] for k in rows), dim=0)

    return result

def torchify(matricess, type=torch.FloatTensor):
    return tuple([type(x).to(device) for x in matricess])
