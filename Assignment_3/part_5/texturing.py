#load the model
#maybe rotate and translate the points with w and t
# normalised_points = model.forward(None)
# actual_points = denormalize(normalised_points.detach().cpu().numpy(), picture)
# demo(picture, actual_points)

# construct G with the four parameters: rotate and translate
# project G to the coordinate system


# We use the found parameters to make G,
# which we project to the coordinate system
# of the image, we then simply use the x,y
# of G to find the corresponding RGB of the
# image. As the x,y coordinates are not discrete
# we use the bilinear interpolation to get the actual RGB values

import numpy as np
import torch
import h5py
import matplotlib.pylab as plt
from model.data_def import Mesh, MyPCAModel
from utils.util_functions import ensure_current_directory
from part_2.mesh_to_png import mesh_to_png
from part_3.pinhole_camera_model import get_projection

def calculate_G(alpha, delta):
    bfm = h5py.File("Data/model2017-1_face12_nomouth.h5", 'r')

    # if alpha is None:
    #     alpha = np.random.uniform(-1, 1, size=30)
    # else:
    #     alpha = alpha.detach().numpy()[0]
    # if delta is None:
    #     delta = np.random.uniform(-1, 1, size=20)
    # else:
    delta = delta.detach().numpy()[0]

    mean_shape = np.asarray(bfm['shape/model/mean'], dtype=np.float32).reshape((-1, 3))
    mean_expression = np.asarray(bfm['expression/model/mean'], dtype=np.float32).reshape((-1, 3))

    basis_shape = np.asarray(bfm['shape/model/pcaBasis'], dtype=np.float32)[:, :30].reshape((-1, 3, 30))
    basis_expression = np.asarray(bfm['expression/model/pcaBasis'], dtype=np.float32)[:, :20].reshape((-1, 3, 20))

    var_shape = np.sqrt(np.asarray(bfm['shape/model/pcaVariance'], dtype=np.float32)[:30])
    var_expression = np.sqrt(np.asarray(bfm['expression/model/pcaVariance'], dtype=np.float32)[:20])

    G = mean_shape + basis_shape @ (alpha * var_shape) \
                       + mean_expression + basis_expression @ (delta * var_expression)

    return np.concatenate((G, np.ones((len(G), 1))), axis=1)

def bilinear_interpolation(points_2d, picture):
    mean_texture = np.zeros((points_2d.shape[0], 3))
    # print(points_2d.shape, frame.shape, points_2d.min(axis=0), points_2d.mean(axis=0), points_2d.max(axis=0))

    # Clip coordinates to be in image...
    points_2d[:, 0] = np.clip(points_2d[:, 0], 0, picture.shape[1] - 1)
    points_2d[:, 1] = np.clip(points_2d[:, 1], 0, picture.shape[0] - 1)

    for i in range(points_2d.shape[0]):
        x1 = points_2d[i, 1]
        x2 = points_2d[i, 0]

        x2_ceil = np.ceil(x2).astype(int)
        x2_floor = np.floor(x2).astype(int)
        x1_ceil = np.ceil(x1).astype(int)
        x1_floor = np.floor(x1).astype(int)

        if (x1_ceil - x1_floor == 0) or (x2_ceil - x2_floor == 0):
            continue

        # Interp over columns
        lower = (x2_ceil - x2) / (x2_ceil - x2_floor) * picture[x1_floor, x2_floor, :] \
                + (x2 - x2_floor) / (x2_ceil - x2_floor) * picture[x1_floor, x2_ceil, :]

        # Interp over next row and then columns
        upper = (x2_ceil - x2) / (x2_ceil - x2_floor) * picture[x1_ceil, x2_floor, :] \
                + (x2 - x2_floor) / (x2_ceil - x2_floor) * picture[x1_ceil, x2_ceil, :]

        intensity = (x1_ceil - x1) / (x1_ceil - x1_floor) * lower \
                    + (x1 - x1_floor) / (x1_ceil - x1_floor) * upper

        if any(np.isnan(intensity)):
            continue

        mean_texture[i, :] = intensity

    return mean_texture

def texturing():

    # my_model = torch.load("Results/model.pt")
    picture = plt.imread("./Data/sjors2.jpg")[:, :, :3]
    # landmarks_3d = ?
    # alpha, delta = my_model.alpha.item(), my_model.delta.item()
    # w1, w2, w3 = model.omega[0].item(), model.omega[1].item(), model.omega[2].item()
    # t1, t2, t3 = model.tau[0].item(), model.tau[1].item(), model.tau[2].item()

    # these values are taken from main 4
    alpha, delta = 0.01611, -0.02186
    w1, w2, w3 = -4.20758, -2.91587, -1.17026
    t1, t2, t3 = 13.58724, -15.46050, -513.25446
    t = np.array([t1, t2, t3]).reshape(3, 1)
    omega = np.array([w1, w2, w3])

    bfm = h5py.File("Data/model2017-1_face12_nomouth.h5", 'r')
    pca_model = MyPCAModel(bfm, 30, 20)  # maybe some other value
    G = pca_model.generate_point_cloud(alpha, delta)

    p_G = get_projection(G, omega, t)

    # plot point cloud
    mean_tex = bilinear_interpolation(p_G, picture)
    triangles = np.asarray(bfm['shape/representer/cells'], dtype=np.int32).T
    mesh = Mesh(G, mean_tex, triangles)
    mesh_to_png("Results/george.png", mesh)


if __name__ == '__main__':
    ensure_current_directory()
    texturing()