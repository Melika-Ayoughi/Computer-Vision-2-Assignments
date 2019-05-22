import torch
import torch.nn as nn
import numpy as np
from model.data_def import MyPCAModel
import h5py
from part_3.pinhole_camera_model import get_projection


class Training(torch.nn.Module):
    def __init__(self, alpha_num, delta_num):
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
            torch.FloatTensor([0, 0.1745, 0]).to(device), requires_grad=True
        )

        self.tau = nn.Parameter(
            torch.FloatTensor([0, 0, -400]).to(device), requires_grad=True
        )

        # load model
        bfm = h5py.File("Data/model2017-1_face12_nomouth.h5", 'r')
        self.pca = MyPCAModel(bfm, 30, 20)

    def forward(self, banana):
        G = (self.pca.generate_point_cloud(self.alphas, self.deltas, torching=True)).to(self.device)

        p_G = get_projection(G, self.omegas, self.tau, torching=True)

        return p_G
