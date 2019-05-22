import os
import torch


device = torch.device('cuda' if torch.cuda.is_available() else 'cpu')

def ensure_current_directory():

    current_dir = os.getcwd()
    os.chdir(current_dir.split("Assignment_3")[0] + "Assignment_3/")


def torchify(matricess, type=torch.FloatTensor):
    return tuple([type(x).to(device) for x in matricess])
