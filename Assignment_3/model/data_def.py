import numpy as np
import torch
from utils.util_functions import torchify


class Mesh:
    def __init__(self, vertices, colors, triangles):
        assert triangles.shape[1] == 3
        assert vertices.shape[1] == 3
        assert colors.shape[1] == 3
        assert vertices.shape[0] == colors.shape[0]

        self.vertices = vertices
        self.colors = colors
        self.triangles = triangles


class PCAModel:

    def __init__(self, mean=None, pc=None, std=None):
        self.mean = mean
        self.pc = pc
        self.std = std


class MyPCAModel(PCAModel):

    def __init__(self, model, n_id, n_exp):
        self.model = model
        self.n_id = n_id
        self.n_exp = n_exp

        # get mean neutral geometry (mu_id)
        mu_id = np.asarray(model['shape/model/mean'], dtype=np.float32).reshape((-1, 3))

        # get mean facial expression (mu_exp)
        mu_exp = np.asarray(model['expression/model/mean'], dtype=np.float32).reshape((-1, 3))

        E_id, sigma_id, E_exp, sigma_exp = self.extract_PCs(model, n_id, n_exp)

        self.G = None

        super().__init__(mean={"id": mu_id, "exp": mu_exp}, pc={"id": E_id, "exp": E_exp},
                         std={"id": sigma_id, "exp": sigma_exp})

    def extract_PCs(self, model, n_id, n_exp):
        # get all principal components for neutral geometry (E_id) and corresponding standard deviation
        E_id = np.asarray(model['shape/model/pcaBasis'], dtype=np.float32).reshape((-1, 3, 199))
        var_id = np.asarray(model['shape/model/pcaVariance'], dtype=np.float32).reshape((199))
        sigma_id = np.sqrt(var_id)

        # get all principal components for facial expression (E_exp) and corresponding standard deviation
        E_exp = np.asarray(model['expression/model/pcaBasis'], dtype=np.float32).reshape((-1, 3, 100))
        var_exp = np.asarray(model['expression/model/pcaVariance'], dtype=np.float32).reshape((100))
        sigma_exp = np.sqrt(var_exp)

        # get specified number of first PCs
        id_subset = np.arange(n_id)
        exp_subset = np.arange(n_exp)

        # get PCs and corresponding sd for facial identity
        E_id_sample = E_id[:, :, id_subset]
        sigma_id_sample = sigma_id[id_subset]

        # get PCs and corresponding sd for expression
        E_exp_sample = E_exp[:, :, exp_subset]
        sigma_exp_sample = sigma_exp[exp_subset]

        return E_id_sample, sigma_id_sample, E_exp_sample, sigma_exp_sample

    def generate_point_cloud(self, alpha, delta, torching=False):
        mu_id, mu_exp, sigma_id, sigma_exp, E_id, E_exp = self.mean["id"], self.mean["exp"], self.std["id"], self.std[
            "exp"], self.pc["id"], self.pc["exp"]

        if (torching):
            mu_id, mu_exp, sigma_id, sigma_exp, E_id, E_exp = torchify(
                [mu_id, mu_exp, sigma_id, sigma_exp, E_id, E_exp])

        G = mu_id + E_id @ (alpha * sigma_id) + mu_exp + E_exp @ (delta * sigma_exp)

        self.G = G

        return G
