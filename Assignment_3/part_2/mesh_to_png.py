from model.data_def import Mesh, MyPCAModel
from utils.util_functions import ensure_current_directory

import matplotlib.pyplot as plt
import matplotlib.image as mpimg
import numpy as np
import trimesh
import pyrender
import h5py
from skimage.io import imsave


def mesh_to_png(file_name, mesh, width=640, height=480, z_camera_translation=400):
    mesh = trimesh.base.Trimesh(
        vertices=mesh.vertices,
        faces=mesh.triangles,
        vertex_colors=mesh.colors)

    mesh = pyrender.Mesh.from_trimesh(mesh, smooth=True, wireframe=False)

    # compose scene
    scene = pyrender.Scene(ambient_light=np.array([1.7, 1.7, 1.7, 1.0]), bg_color=[255, 255, 255])
    camera = pyrender.PerspectiveCamera(yfov=np.pi / 3.0)
    light = pyrender.DirectionalLight(color=[1, 1, 1], intensity=2e3)

    scene.add(mesh, pose=np.eye(4))
    scene.add(light, pose=np.eye(4))

    # Added camera translated z_camera_translation in the 0z direction w.r.t. the origin
    scene.add(camera, pose=[[1, 0, 0, 0],
                            [0, 1, 0, 0],
                            [0, 0, 1, z_camera_translation],
                            [0, 0, 0, 1]])

    # render scene
    r = pyrender.OffscreenRenderer(width, height)
    color, _ = r.render(scene)

    # imsave(file_name, color)


def plot_PC():
    # make a subplot figure with the different generated point clouds plotted
    for i in range(20):
        # read image
        I = mpimg.imread("Results/Morphable_Model/pc_" + str(i) + ".png")

        plt.subplot(5, 4, i + 1)  # adjust according to size of subplot
        plt.imshow(I)

    plt.show()


def main_2(n_samples=50, n_id=30, n_exp=30):
    bfm = h5py.File("Data/model2017-1_face12_nomouth.h5", 'r')

    mean_shape = np.asarray(bfm['shape/model/mean'], dtype=np.float32).reshape((-1, 3))
    mean_tex = np.asarray(bfm['color/model/mean'], dtype=np.float32).reshape((-1, 3))

    triangles = np.asarray(bfm['shape/representer/cells'], dtype=np.int32).T

    # sample 50 alpha and delta uniformly
    alphas, deltas = map(lambda x: np.random.uniform(-1, 1, n_samples), range(2))

    # initialize figure
    plt.figure(1)

    model = MyPCAModel(bfm, n_id, n_exp)

    for i in range(n_samples):

        alpha = alphas[i]
        delta = deltas[i]

        G = model.generate_point_cloud(alpha, delta)

        # plot point cloud
        mesh = Mesh(G, mean_tex, triangles)
        mesh_to_png("Results/Morphable_Model/pc_" + str(i) + ".png", mesh)

    plot_PC()


if __name__ == '__main__':
    ensure_current_directory()
    main_2()
