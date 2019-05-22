from utils.util_functions import *
import matplotlib.pylab as plt
import torch
import torch.nn.functional as F
from torch.autograd import Variable
from model.training_model import Training

from part_4.landmarks import *

pdist = torch.nn.PairwiseDistance(p=2)  # TODO: CHANGE

def loss_total(alphas, deltas, p, ground_truth, lambda_alpha=1.0, lambda_delta=1.0):
    L_lan = torch.sum(pdist(p, ground_truth) ** 2)
    L_reg = lambda_alpha * torch.sum(alphas ** 2) + lambda_delta * torch.sum(deltas ** 2)
    L_fit = L_lan + L_reg

    return L_fit
                            ## TODO: change

    # loss_lan = F.mse_loss(p, ground_truth)
    #
    # loss_reg = loss_reg_function(lambda_alpha, lambda_delta, alphas, deltas)
    #
    # return loss_reg + loss_lan


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




def train(ground_truth, lambda_alpha=1.0, lambda_delta=1.0, lr=0.001,
          steps=1000):

    device = torch.device('cuda' if torch.cuda.is_available() else 'cpu')

    model = Training()

    model.to(device)

    opt = torch.optim.Adam(model.parameters(), lr=lr)

    ground_truth = torchify([ground_truth.numpy()])[0]

    for i in range(steps):

        opt.zero_grad()

        p = model.forward(0)

        loss = loss_total(model.alphas, model.deltas, p, ground_truth, lambda_alpha=lambda_alpha, lambda_delta=lambda_delta)

        loss.backward()

        opt.step()

        print(f"\rEpoch: {i}, Loss: {loss.item()} alpha: {model.alphas.item()}, delta: {model.deltas.item()}, omega: [{model.omegas[0].item()}, {model.omegas[1].item()}, {model.omegas[2].item()}], tau [{model.tau[0].item()}, {model.tau[1].item()}, {model.tau[2].item()}]", end='')

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
    alphas, deltas, omegas, tau = train(torch.LongTensor(points), lr=0.1)

    # 4.3
    ## TODO

if __name__ == '__main__':
    ensure_current_directory()
    main_4()
