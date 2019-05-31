import numpy as np
import torch
import torch.nn as nn
from model.data_def import MyPCAModel
import h5py
from part_3.pinhole_camera_model import get_projection
from utils.util_functions import torchify, torchify_2, create_mask


class Training(torch.nn.Module):
    def __init__(self, picture):
        super().__init__()

        self.picture = picture

        device = torch.device('cuda' if torch.cuda.is_available() else 'cpu')

        self.activation = nn.Sigmoid()

        self.device = device

        self.alpha = nn.Parameter(
            torch.zeros((1)).to(device), requires_grad=True
        )

        self.delta = nn.Parameter(
            torch.zeros((1)).to(device), requires_grad=True
        )

        self.omega = nn.Parameter(
            torch.FloatTensor([0.0, 0.0, 0.0]).to(device), requires_grad=True
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
        # create point cloud
        G = (self.pca.generate_point_cloud(self.alpha, self.delta, torching=True)).to(self.device)

        # project
        p_G = get_projection((G), self.omega.view(3, 1), self.tau.view(3, 1), torching=True, device=self.device,
                             picture_shape=self.picture.shape)

        return (p_G[self.subset, :])
