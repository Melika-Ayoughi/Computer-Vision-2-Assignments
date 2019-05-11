import os
import numpy as np
import trimesh
import pyrender

import h5py

from data_def import PCAModel, Mesh

bfm = h5py.File("model2017-1_face12_nomouth.h5", 'r')

mean_shape = np.asarray(bfm['shape/model/mean'], dtype=np.float32).reshape((-1, 3))
mean_tex = np.asarray(bfm['color/model/mean'], dtype=np.float32).reshape((-1, 3))

triangles = np.asarray(bfm['shape/representer/cells'], dtype=np.int32).T

#################################################### Extract the PCA model for facial identity


def extract_PCs(model, n_id, n_exp):

    #get all principal components for neutral geometry (E_id) and corresponding standard deviation
    E_id = np.asarray(model['shape/model/pcaBasis'], dtype=np.float32).reshape((-1, 3, 199))
    var_id = np.asarray(model['shape/model/pcaVariance'], dtype=np.float32).reshape((199))
    sigma_id = np.sqrt(var_id)


    #get all principal components for facial expression (E_exp) and corresponding standard deviation
    E_exp = np.asarray(model['expression/model/pcaBasis'], dtype=np.float32).reshape((-1, 3, 100))
    var_exp = np.asarray(model['expression/model/pcaVariance'], dtype=np.float32).reshape((100))
    sigma_exp = np.sqrt(var_exp)

    print(var_exp)


    # sample randomly 30 PCs for facial identity and 20 PCs for expression
    # permutations = np.random.permutation(np.size(E_id,2))
    # id_subset = permutations[:n_id]

    id_subset = np.arange(n_id)

    # permutations = np.random.permutation(np.size(E_exp,2))
    # exp_subset = permutations[:n_exp]
    exp_subset = np.arange(n_exp)

    #get PCs and corresponding sd for facial identity
    E_id_sample = E_id[:,:,id_subset]
    sigma_id_sample = sigma_id[id_subset]

    #get PCs and corresponding sd for expression
    E_exp_sample = E_exp[:,:,exp_subset]
    sigma_exp_sample = sigma_exp[exp_subset]

    return E_id_sample, sigma_id_sample, E_exp_sample, sigma_exp_sample

def generate_point_cloud(alpha, delta, mu_id, mu_exp, E_id, sigma_id, E_exp, sigma_exp):

    G = mu_id + E_id @ (alpha * sigma_id) + mu_exp + E_exp @ (delta * sigma_exp)

    return G


# get specified number of PCs
E_id, sigma_id, E_exp, sigma_exp = extract_PCs(bfm, 30, 20)


# get mean neutral geometry (mu_id)
mu_id = np.asarray(bfm['shape/model/mean'], dtype=np.float32).reshape((-1, 3))

# get mean facial expression (mu_exp)
mu_exp = np.asarray(bfm['expression/model/mean'], dtype=np.float32).reshape((-1, 3))


#####################################################

def mesh_to_png(file_name, mesh):
    mesh = trimesh.base.Trimesh(
        vertices=mesh.vertices,
        faces=mesh.triangles,
        vertex_colors=mesh.colors)

    png = mesh.scene().save_image()
    with open(file_name, 'wb') as f:
        f.write(png)

if __name__ == '__main__':
    # mesh = Mesh(mean_shape, mean_tex, triangles)
    # mesh_to_png("debug.png", mesh)


    # set number point cloud samples
    n_samples = 50

    # sample 50 alphas and deltas
    alphas = np.random.uniform(-1,1,n_samples)
    deltas = np.random.uniform(-1,1,n_samples)

    for i in range(n_samples):
        # uniformly sample alpha and delta
        alpha = alphas[i]
        delta = deltas[i]

        # get point cloud
        G = generate_point_cloud(alpha, delta, mu_id, mu_exp, E_id, sigma_id, E_exp, sigma_exp)

        # plot point cloud
        mesh = Mesh(G, mean_tex, triangles)
        mesh_to_png("Results/Morphable_Model/pc_" + str(i) + ".png", mesh)
