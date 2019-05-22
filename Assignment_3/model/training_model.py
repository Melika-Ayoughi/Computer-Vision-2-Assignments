import numpy as np
import torch
import torch.nn as nn
from model.data_def import MyPCAModel
import h5py
from part_3.pinhole_camera_model import get_projection
from utils.util_functions import torchify


class Training(torch.nn.Module):
    def __init__(self):
        super().__init__()

        device = torch.device('cuda' if torch.cuda.is_available() else 'cpu')

        self.device = device

        self.alphas = nn.Parameter(
            torch.randn((1)).to(device), requires_grad=True
        )

        self.deltas = nn.Parameter(
            torch.randn((1)).to(device), requires_grad=True
        )

        self.omegas = nn.Parameter(
            torch.FloatTensor([0.0000001, 0.1745, 0.0000001]).to(device), requires_grad=True
        )

        self.tau = nn.Parameter(
            torch.FloatTensor([0, 0, -400]).to(device), requires_grad=True
        )

        # load model
        bfm = h5py.File("Data/model2017-1_face12_nomouth.h5", 'r')
        self.pca = MyPCAModel(bfm, 30, 20)

        # import landmark subset idxs
        with open("Data/Landmarks68_model2017-1_face12_nomouth.anl", mode="r", encoding="utf-8") as f:
            data = f.read().splitlines()
            self.subset = torchify([list(map(int, data))], type=torch.LongTensor)[0]

    def forward(self, _):
        G = (self.pca.generate_point_cloud(self.alphas, self.deltas, torching=True)).to(self.device)

        p_G = get_projection(G, self.omegas.view(3, 1), self.tau.view(3, 1), torching=True)

        return p_G[self.subset, :]
