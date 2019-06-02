import torch
import torch.nn as nn
from model.data_def import MyPCAModel
import h5py
from part_3.pinhole_camera_model import get_projection
from utils.util_functions import torchify


class Training(torch.nn.Module):
    def __init__(self, picture, normalised=False, init_alph=0, init_delt=0, init_omega=(0, 0, 0),
                 init_tau=(0, 0, -400)):
        super().__init__()

        self.normalised = normalised

        self.picture = picture

        device = torch.device('cuda' if torch.cuda.is_available() else 'cpu')

        self.activation = nn.Sigmoid()

        self.device = device

        # alpha param
        self.alpha = nn.Parameter(
            torch.FloatTensor([init_alph]).to(device), requires_grad=True
        )

        # delta param
        self.delta = nn.Parameter(
            torch.FloatTensor([init_delt]).to(device), requires_grad=True
        )

        # rotation
        self.omega = nn.Parameter(
            torch.FloatTensor(list(init_omega)).to(device), requires_grad=True
        )

        # translation
        self.tau = nn.Parameter(
            torch.FloatTensor(list(init_tau)).to(device), requires_grad=True
        )

        # additional scaling and translation
        self.batchnorm = nn.BatchNorm1d(2)

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

        # normalise if needed
        if (self.normalised):
            return self.batchnorm(p_G[self.subset, :])
        else:
            return p_G[self.subset, :]
