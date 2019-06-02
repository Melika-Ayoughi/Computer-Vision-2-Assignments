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

def texturing():

    my_model = torch.load("Results/model.pt")
    # landmarks_3d = ?

    # alpha, delta = my_model.alpha.item(), my_model.delta.item()
    # w1, w2, w3 = model.omega[0].item(), model.omega[1].item(), model.omega[2].item()
    # t1, t2, t3 = model.tau[0].item(), model.tau[1].item(), model.tau[2].item()

    alpha, delta =my_model.alpha.item(), my_model.delta.item()
    w1, w2, w3 = model.omega[0].item(), model.omega[1].item(), model.omega[2].item()
    t1, t2, t3 = model.tau[0].item(), model.tau[1].item(), model.tau[2].item()

    bfm = h5py.File("Data/model2017-1_face12_nomouth.h5", 'r')
    pca_model = MyPCAModel(bfm, 30, 30)  # maybe some other value
    G = pca_model.generate_point_cloud(alpha, delta)

    # plot point cloud
    mesh = Mesh(G, mean_tex, triangles)
    mesh_to_png("Results/Morphable_Model/pc_" + str(i) + ".png", mesh)

    # plot point cloud
    # mesh = Mesh(G, mean_tex, triangles)
    # mesh_to_png("Results/Morphable_Model/pc_" + str(i) + ".png", mesh)

    # point_cloud_original = calculate_G(alpha, delta)

    # point_cloud = point_cloud_original
    # if type(point_cloud) is np.ndarray:
    #     point_cloud = torch.from_numpy(point_cloud).to(T_DTYPE)
    # point_cloud = do_transform(point_cloud, w1, w2, w3, t)
    # # point_cloud, p = normalize(point_cloud, *gt_normalize_params, pad=True)
    #
    # # We have some error here, we normalize using the own point cloud statistics and then denormalize using the
    # # gt_normalize_params...
    # point_cloud, p = normalize(point_cloud)
    # point_cloud = denormalize(point_cloud[:, 0:3], *gt_normalize_params, pad=True)
    # # point_cloud = (point_cloud[:, 0:3].t() / point_cloud[:, 2]).t()
    # point_cloud = point_cloud.clone().detach().numpy()
    #
    # mean_tex = bilinear_interp(point_cloud, frame)
    #
    # # point_cloud = denormalize(point_cloud, p[0][0:3], p[1][0:3])
    # # triangles = Delaunay(point_cloud[:, 0:2]).simplices
    #
    # im_name = f"./images/texturing.png"
    #
    # bfm = h5py.File("./model2017-1_face12_nomouth.h5", 'r')
    # # mean_tex = np.asarray(bfm['color/model/mean'], dtype=np.float32).reshape((-1, 3))
    # triangles = np.asarray(bfm['shape/representer/cells'], dtype=np.int32).T
    #
    # mesh = Mesh(point_cloud_original[:, 0:3], mean_tex, triangles)
    # mesh_to_png(im_name, mesh, width=frame.shape[1], height=frame.shape[0])
    # # mesh_to_png(im_name, mesh)
    # plt.show()
    #
    # plt.imshow(frame)
    # plt.scatter(point_cloud[:, 0], point_cloud[:, 1])
    # # landmarks_2d = (landmarks_3d[:, 0:2].t() / landmarks_3d[:, 2]).t()
    # landmarks_2d = landmarks_3d[:, 0:2]
    # plt.scatter(landmarks_2d[:, 0], landmarks_2d[:, 1])
    # plt.show()

if __name__ == '__main__':
    ensure_current_directory()
    texturing()