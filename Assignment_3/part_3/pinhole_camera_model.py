import matplotlib.pyplot as plt
import numpy as np
import h5py
from utils.util_functions import *
from model.data_def import Mesh, MyPCAModel
from part_2.mesh_to_png import mesh_to_png

import math


def generate_R(omega, torching=False, device="cpu"):
    # convert input from degrees to radians
    omega = omega * (math.pi / 180)

    if (torching):

        # get rotation about x-axis
        R_x = torchify_2(

            [[1, 0, 0],
             [0, torch.cos(omega[0]), -torch.sin(omega[0])],
             [0, torch.sin(omega[0]), torch.cos(omega[0])]
             ], 3, device=device

        )

        # get rotation about y-axis
        R_y = torchify_2(
            [[torch.cos(omega[1]), 0, torch.sin(omega[1])],
             [0, 1, 0],
             [-1 * torch.sin(omega[1]), 0, torch.cos(omega[1])]
             ]
            , 3, device=device
        )

        # get rotation about z-axis
        R_z = torchify_2(

            [[torch.cos(omega[2]), -1 * torch.sin(omega[2]), 0],
             [torch.sin(omega[2]), torch.cos(omega[2]), 0],
             [0, 0, 1]
             ]
            , 3, device=device
        )


    else:

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

    return R


def generate_T(R, t, torching=False, device="cpu"):
    if (torching):

        T = torch.cat((R, t), dim=1)

        # initialize last row of matrix
        l_r = create_mask([0, 0, 0, 1], device=device).view(1, 4)

        # concatenate last row to the rest
        T = torch.cat((T, l_r), dim=0)


    else:

        T = np.concatenate((R, t), axis=1)

        # initialize last row of matrix
        l_r = np.zeros(4).reshape(1, 4)
        l_r[0, 3] = 1

        # concatenate last row to the rest
        T = np.concatenate((T, l_r), axis=0)

    return T


def generate_P(fov, width, height, near, far, torching=False, device="cpu"):
    n = near
    f = far

    if (torching):

        # compute parameters
        aspect_ratio = (width / height)
        t = math.tan(fov / 2) * n
        b = -t
        r = t * aspect_ratio
        l = -t * aspect_ratio

        P = torchify_2(
            [[2 * n / (r - l), 0, 0, 0],
             [0, 2 * n / (t - b), 0, 0],
             [(r + l) / (r - l), (t + b) / (t - b), -(f + n) / (f - n), -1],
             [0, 0, -1, 0]
             ]
            , 4, device=device)

    else:

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


# def generate_V(v_r, v_l, v_t, v_b, torching=False, device="cpu"):
def generate_V(cx, cy, torching=False, device="cpu"):
    if (torching):
        #
        # V = torchify_2(
        #     [[(v_r - v_l) / 2, 0, 0, (v_r + v_l) / 2],
        #      [0, (v_t - v_b) / 2, 0, (v_t + v_b) / 2],
        #      [0, 0, 1 / 2, 1 / 2],
        #      [0, 0, 0, 1]
        #      ]
        #     , 4, device=device)

        V = torchify_2([[cx, 0, 0, cx],
                        [0, -cy, 0, cy],
                        [0, 0, 0.5, 0.5],
                        [0, 0, 0, 1]], 4, device=device)

    # else:
    #     V = np.array([[(v_r - v_l) / 2, 0, 0, (v_r + v_l) / 2],
    #                   [0, (v_t - v_b) / 2, 0, (v_t + v_b) / 2],
    #                   [0, 0, 1 / 2, 1 / 2],
    #                   [0, 0, 0, 1]
    #                   ])

    return V


def homogenize(input, torching=False, device="cpu"):
    # get dimensions
    rows = input.shape[0]

    if (torching):

        elem = torchify([torch.ones(rows).view((rows, 1))])[0]
        # add homogenous coordinates
        h_input = torch.cat((input, elem), dim=1)

    else:

        # add homogenous coordinates
        h_input = np.concatenate((input, np.ones(rows).reshape((rows, 1))), axis=1)

    return h_input


def dehomogenize(input, torching=False, device="cpu"):
    # get dimesnions
    rows, columns = input.shape

    if (torching):

        # initialize dehomogenized version
        d_input = torchify(torch.empty((rows, 0)))[0]

        # divide each row by final row
        for c in range(columns - 1):
            new_column = input[:, c] / (input[:, -1])
            d_input = torch.cat((d_input, new_column.view(new_column.shape[0], 1)), dim=1)

    else:

        # initialize dehomogenized version
        d_input = np.empty((rows, 0), int)

        # divide each row by final row
        for c in range(columns - 1):
            new_column = input[:, c] / input[:, -1]
            d_input = np.concatenate((d_input, new_column.reshape(new_column.shape[0], 1)), axis=1)

    return d_input


def get_projection(G, omega, tau, torching=False, device="cpu", picture_shape=None):
    # make G homogenous
    h_G = homogenize(G, torching=torching, device=device)

    # get width
    if (picture_shape is None):
        G_x = G[:, 0]
        width = G_x.max() - G_x.min()
    else:
        width = picture_shape[0]

    # get height
    if (picture_shape is None):
        G_y = G[:, 1]
        height = G_y.max() - G_y.min()
    else:
        height = picture_shape[1]

    # get near and far using z
    near = 300
    far = 2000

    # get P
    P = generate_P(0.5, width, height, near, far, torching=torching, device=device)

    # get V
    V = generate_V(width / 2, height / 2, torching=torching, device=device)

    # construct rotation matrix and translation vector
    R = generate_R(omega, torching=torching, device=device)
    T = generate_T(R, tau, torching=torching, device=device)

    # project to 2D plane

    if (torching):
        p_G = (V @ P) @ (T @ h_G.t())
        p_G = dehomogenize(p_G.t(), torching=torching, device=device)
    else:
        p_G = (V @ P) @ (T @ h_G.T)
        p_G = dehomogenize(p_G.T, torching=torching, device=device)

    return p_G[:, 0:2]


def main_3():
    # load model
    bfm = h5py.File("Data/model2017-1_face12_nomouth.h5", 'r')
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
    t[0] = -400

    # construct rotation matrix and translation vector
    R = generate_R(omega)
    T = generate_T(R, t)

    # transform G
    t_h_G = T @ h_G.T

    # dehomogenize G
    t_G = dehomogenize(t_h_G.T)

    #################################### 3(a)

    # plot point cloud
    # mesh = Mesh(t_G, mean_tex, triangles)
    #
    # mesh_to_png("./Results/debug.png", mesh)

    #################################### 3(b)

    # project to 2D
    p_G = get_projection(G, omega, t)

    # import landmark subset idxs
    with open("Data/Landmarks68_model2017-1_face12_nomouth.anl", mode="r", encoding="utf-8") as f:
        data = f.read().splitlines()
        subset = list(map(int, data))

    # plot subset
    plt.scatter(p_G[subset, 0], p_G[subset, 1])
    plt.savefig("./Results/2D_image_plane.png")
    plt.show()

    return p_G


if __name__ == '__main__':
    ensure_current_directory()

    main_3()
