import torch
import torch.nn
import numpy as np
from model.data_def import MyPCAModel
import h5py

class Training(torch.nn.Module):
    def __init__(self, alpha_num, delta_num):
        super().__init__()

        device = torch.device('cuda' if torch.cuda.is_available() else 'cpu')

        self.device = device

        self.alphas = (torch.randn((alpha_num), requires_grad=True)).to(device)
        self.omegas = (torch.randn([0, 0.1745, 0], requires_grad=True)).to(device)
        self.tau = (torch.randn([0, 0, -400], requires_grad=True)).to(device)
        self.deltas = (torch.randn((delta_num), requires_grad=True)).to(device)

        # load model
        bfm = h5py.File("Data/model2017-1_face12_nomouth.h5", 'r')
        mean_tex = np.asarray(bfm['color/model/mean'], dtype=np.float32).reshape((-1, 3))
        triangles = np.asarray(bfm['shape/representer/cells'], dtype=np.int32).T

        self.pca = MyPCAModel(bfm, 30, 20)

    def forward(self, input):

        G = torch.FloatTensor(self.pca.generate_point_cloud(self.alpha, self.delta)).to(self.device)


        pass
