import matplotlib.pyplot as plt
import numpy as np
import h5py

from utils.util_functions import *
from model.data_def import Mesh, MyPCAModel
from part_2.mesh_to_png import mesh_to_png

def generate_R(omega):
    # convert input from degrees to radians
    omega = omega * (np.pi / 180)

    # get rotation about x-axis
    R_x = np.array([[1, 0, 0],
                    [0, np.cos(omega[0]), -np.sin(omega[0])],
                    [0, np.sin(omega[0]), np.cos(omega[0])]
                    ])

    # get rotation about y-axis
    R_y = np.array([[np.cos(omega[1]), 0, np.sin(omega[1])],
                    [0, 1, 0],
                    [-np.sin(omega[1]), 0, np.cos(omega[1])]
                    ])

    # get rotation about z-axis
    R_z = np.array([[np.cos(omega[2]), -np.sin(omega[2]), 0],
                    [np.sin(omega[2]), np.cos(omega[2]), 0],
                    [0, 0, 1]
                    ])

    # get overall rotation matrix
    R = R_z @ R_y @ R_x
    # R = R_x @ R_y @ R_z

    return R


def generate_T(R, t):
    T = np.concatenate((R, t), axis=1)

    # initialize last row of matrix
    l_r = np.zeros(4).reshape(1, 4)
    l_r[0, 3] = 1

    # concatenate last row to the rest
    T = np.concatenate((T, l_r), axis=0)

    return T


def generate_P(fov, width, height, near, far):
    n = near
    f = far

    # compute parameters
    aspect_ratio = (width / height)
    t = np.tan(fov / 2) * n
    b = -t
    r = t * aspect_ratio
    l = -t * aspect_ratio

    P = np.array([[2 * n / (r - l), 0, 0, 0],
                  [0, 2 * n / (t - b), 0, 0],
                  [(r + l) / (r - l), (t + b) / (t - b), -(f + n) / (f - n), -1],
                  [0, 0, -(2 * f * n) / (f - n), 0]
                  ])

    return P


def generate_V(v_r, v_l, v_t, v_b):
    V = np.array([[(v_r - v_l) / 2, 0, 0, (v_r + v_l) / 2],
                  [0, (v_t - v_b) / 2, 0, (v_t + v_b) / 2],
                  [0, 0, 1 / 2, 1 / 2],
                  [0, 0, 0, 1]
                  ])

    # V = np.array([[(v_r - v_l)/2, 0, 0, 0],
    #               [0, 0, (v_t - v_b)/2, 0],
    #               [0, 0, 1/2, 0],
    #               [0, 0, 0, 1]
    #               ])

    return V


def homogenize(input):
    # get dimensions
    [rows, _] = input.shape

    # add homogenous coordinates
    h_input = np.concatenate((input, np.ones(rows).reshape((rows, 1))), axis=1)

    return h_input


def dehomogenize(input):
    # get dimesnions
    [rows, columns] = input.shape

    # initialize dehomogenized version
    d_input = np.empty((rows, 0), int)

    # divide each row by final row
    for c in range(columns - 1):
        new_column = input[:, c] / input[:, -1]
        d_input = np.concatenate((d_input, new_column.reshape(new_column.shape[0], 1)), axis=1)

    return d_input


def main_3():
    # load model
    bfm = h5py.File("Data/model2017-1_face12_nomouth.h5",
                    'r')  # could not load model so made a folder Data/ containing the model in part 3 directory
    mean_tex = np.asarray(bfm['color/model/mean'], dtype=np.float32).reshape((-1, 3))
    triangles = np.asarray(bfm['shape/representer/cells'], dtype=np.int32).T

    # initialize PCA model
    model = MyPCAModel(bfm, 30, 20)

    # use fixed alpha and delta
    alpha = 0
    delta = 0

    # get a point cloud
    G = model.generate_point_cloud(alpha, delta)

    # make G homogenous
    h_G = homogenize(G)

    # initialize omega and t
    omega = np.array([0, 10, 0])
    t = np.zeros(3).reshape(3, 1)

    # translation over the z dimension
    t[2] = -400

    # construct rotation matrix and translation vector
    R = generate_R(omega)
    T = generate_T(R, t)

    # transform G
    t_h_G = T @ h_G.T

    # dehomogenize G
    t_G = dehomogenize(t_h_G.T)

    # plot point cloud
    mesh = Mesh(t_G, mean_tex, triangles)

    mesh_to_png("./Results/debug.png", mesh)

    #################################### 3(b)

    # get width
    G_x = G[:, 0]
    width = G_x.max() - G_x.min()

    # get height
    G_y = G[:, 1]
    height = G_y.max() - G_y.min()

    # get near and far using z
    G_z = G[:, 2]
    near = G_z.min()
    far = G_z.max()

    # get P
    P = generate_P(0.5, width, height, near, far)

    # get V
    V = generate_V(G_x.max() / 2, G_x.min() / 2, G_y.max() / 2, G_y.min() / 2)

    # import landmark subset idxs
    with open("Data/model2017-1_face12_nomouth.anl", mode="r", encoding="utf-8") as f:
        data = f.read().splitlines()
        subset = list(map(int, data))

    # project to 2D plane
    p_G = (V @ P) @ (T @ h_G.T)
    p_G = dehomogenize(p_G.T)
    p_G = dehomogenize(p_G)

    # plot subset
    plt.scatter(p_G[subset, 0], p_G[subset, 1])
    plt.savefig("./Results/2D_image_plane.png")
    plt.show()


if __name__ == '__main__':
    ensure_current_directory()

    main_3()
