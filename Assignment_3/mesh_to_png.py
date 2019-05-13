# import os
# import numpy as np
# import trimesh
# import pyrender
#
import matplotlib.pyplot as plt ###############################
import matplotlib.image as mpimg
#
# import h5py
#
# from data_def import PCAModel, Mesh
#
# bfm = h5py.File("Data/model2017-1_face12_nomouth.h5", 'r')
#
# mean_shape = np.asarray(bfm['shape/model/mean'], dtype=np.float32).reshape((-1, 3))
# mean_tex = np.asarray(bfm['color/model/mean'], dtype=np.float32).reshape((-1, 3))
#
# triangles = np.asarray(bfm['shape/representer/cells'], dtype=np.int32).T


import os
from skimage.io import imsave
import numpy as np
import trimesh
import pyrender

import h5py

from data_def import PCAModel, Mesh

bfm = h5py.File("Data/model2017-1_face12_nomouth.h5", 'r')

mean_shape = np.asarray(bfm['shape/model/mean'], dtype=np.float32).reshape((-1, 3))
mean_tex = np.asarray(bfm['color/model/mean'], dtype=np.float32).reshape((-1, 3))

triangles = np.asarray(bfm['shape/representer/cells'], dtype=np.int32).T

def mesh_to_png(file_name, mesh, width=640, height=480, z_camera_translation=400):
    mesh = trimesh.base.Trimesh(
        vertices=mesh.vertices,
        faces=mesh.triangles,
        vertex_colors=mesh.colors)

    mesh = pyrender.Mesh.from_trimesh(mesh, smooth=True, wireframe=False)

    # compose scene
    scene = pyrender.Scene(ambient_light=np.array([1.7, 1.7, 1.7, 1.0]), bg_color=[255, 255, 255])
    camera = pyrender.PerspectiveCamera( yfov=np.pi / 3.0)
    light = pyrender.DirectionalLight(color=[1,1,1], intensity=2e3)

    scene.add(mesh, pose=np.eye(4))
    scene.add(light, pose=np.eye(4))

    # Added camera translated z_camera_translation in the 0z direction w.r.t. the origin
    scene.add(camera, pose=[[ 1,  0,  0,  0],
                            [ 0,  1,  0,  0],
                            [ 0,  0,  1,  z_camera_translation],
                            [ 0,  0,  0,  1]])

    # render scene
    r = pyrender.OffscreenRenderer(width, height)
    color, _ = r.render(scene)

    imsave(file_name, color)


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



    # sample randomly 30 PCs for facial identity and 20 PCs for expression
    # permutations = np.random.permutation(np.size(E_id,2))
    # id_subset = permutations[:n_id]

    # permutations = np.random.permutation(np.size(E_exp,2))
    # exp_subset = permutations[:n_exp]

    # get specified number of first PCs
    id_subset = np.arange(n_id)
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

# def mesh_to_png(file_name, mesh):
#     mesh = trimesh.base.Trimesh(
#         vertices=mesh.vertices,
#         faces=mesh.triangles,
#         vertex_colors=mesh.colors)
#
#     png = mesh.scene().save_image()
#     with open(file_name, 'wb') as f:
#         f.write(png)

if __name__ == '__main__':
    # mesh = Mesh(mean_shape, mean_tex, triangles)
    # mesh_to_png("debug.png", mesh)

    # set number point cloud samples
    n_samples = 50

    # sample 50 alphas and deltas
    alphas = np.random.uniform(-1,1,n_samples)
    deltas = np.random.uniform(-1,1,n_samples)

    # initialize figure
    plt.figure(1)

    for i in range(n_samples):

        # uniformly sample alpha and delta
        alpha = alphas[i]
        delta = deltas[i]

        # get point cloud
        G = generate_point_cloud(alpha, delta, mu_id, mu_exp, E_id, sigma_id, E_exp, sigma_exp)

        # plot point cloud
        mesh = Mesh(G, mean_tex, triangles)
        mesh_to_png("Results/Morphable_Model/pc_" + str(i) + ".png", mesh)





# make a subplot figure with the different generated point clouds plotted
for i in range(20):

    #read image
    I = mpimg.imread("Results/Morphable_Model/pc_" + str(i) + ".png")

    print(i+1)

    plt.subplot(5,4,i+1) #adjust according to size of subplot
    plt.imshow(I)

plt.show()
