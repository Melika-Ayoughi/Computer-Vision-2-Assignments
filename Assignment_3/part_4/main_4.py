from utils.util_functions import *
import matplotlib.pylab as plt
import torch
import torch.nn.functional as F
from torch.autograd import Variable
from model.training_model import Training

from part_4.landmarks import *


def loss_total(alphas, deltas, p, ground_truth, lambda_alpha=1.0, lambda_delta=1.0):
    loss_lan = F.mse_loss(p, ground_truth)

    loss_reg = loss_reg_function(lambda_alpha, lambda_delta, alphas, deltas)

    return loss_reg + loss_lan


def loss_reg_function(lambda_alpha, lambda_delta, alphas, deltas):
    return lambda_alpha * torch.sum(alphas.pow(2)) + lambda_delta * torch.sum(deltas.pow(2))


def extract_ground_truth(face):
    points = detect_landmark(face)

    return np.array(points)


def read_file_points():
    with open("Data/model2017-1_face12_nomouth.anl", mode="r", encoding="utf-8") as f:
        data = f.read().splitlines()
        subset = list(map(int, data))
        return subset


def get_projected_points(alphas, deltas, omegas, tau, avg):
    # import landmark subset idxs

    return ""


def train(alpha_shape, delta_shape, omega_shape, tau_shape, ground_truth, lambda_alpha=1.0, lambda_delta=1.0, lr=0.001,
          steps=1000):

    device = torch.device('cuda' if torch.cuda.is_available() else 'cpu')

    model = Training(alpha_shape, omega_shape, tau_shape, delta_shape)

    model.to(device)

    avg = read_file_points()

    avg = torch.FloatTensor(avg).to(device)

    opt = torch.optim.Adam(model.parameters(), lr=lr)

    ground_truth.to(device)

    for i in range(steps):
        opt.zero_grad()

        p = get_projected_points(model.alphas, model.deltas, model.omegas, model.tau, avg)

        loss = loss_total(model.alphas, model.deltas, p, ground_truth, lambda_alpha=lambda_alpha, lambda_delta=lambda_delta)

        loss.backward()
        opt.step()

    return model


def demo(picture, points):
    plt.imshow(picture)
    plt.scatter(points[:, 0], points[:, 1])
    plt.xticks([])
    plt.yticks([])
    plt.savefig("./Results/part_4_initial_face.png")
    plt.show()


def main_4():
    # extract
    picture = plt.imread("./Data/elias.jpg")
    points = extract_ground_truth(picture)

    # 4.1
    demo(picture, points)

    # 4.2
    alphas, deltas, omegas, tau = train((1, 30), (1, 30), (3, 1), (3, 1), torch.LongTensor(points))

    # 4.3


if __name__ == '__main__':
    ensure_current_directory()
    main_4()
