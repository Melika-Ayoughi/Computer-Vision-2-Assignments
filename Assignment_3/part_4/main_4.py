from utils.util_functions import *
import matplotlib.pylab as plt
import torch
from model.training_model import Training
from model.data_management import DataManager
from part_4.landmarks import *

pdist = torch.nn.PairwiseDistance(p=2)


def loss_total(alpha, delta, p, ground_truth, lambda_alpha=1.0, lambda_delta=1.0):
    loss_lan = torch.sum(pdist(p, ground_truth) ** 2)

    loss_reg = loss_reg_function(lambda_alpha, lambda_delta, alpha, delta)

    return loss_reg + loss_lan


def loss_reg_function(lambda_alpha, lambda_delta, alpha, delta):
    return lambda_alpha * torch.sum(alpha.pow(2)) + lambda_delta * torch.sum(delta.pow(2))


def extract_ground_truth(face):
    points = detect_landmark(face)

    return np.array(points)


def train(ground_truth, lambda_alpha=1.0, lambda_delta=1.0, lr=0.001, steps=2000, exit_codition=None):
    device = torch.device('cuda' if torch.cuda.is_available() else 'cpu')

    model = Training()

    model.to(device)

    opt = torch.optim.Adam(model.parameters(), lr=lr)

    ground_truth = torchify([ground_truth.numpy()])[0]

    for i in range(steps):
        opt.zero_grad()

        p = model.forward(None)

        loss = loss_total(model.alpha, model.delta, p, ground_truth, lambda_alpha=lambda_alpha,
                          lambda_delta=lambda_delta)

        loss.backward()

        opt.step()

        print(
            f"\rEpoch: {i}, Loss: {int(loss.item())} alpha: {model.alpha.item():0.5f}, delta: {model.delta.item():0.5f}, omega: [{model.omega[0].item():0.5f}, {model.omega[1].item():0.5f}, {model.omega[2].item():0.5f}], tau [{model.tau[0].item():0.5f}, {model.tau[1].item():0.5f}, {model.tau[2].item():0.5f}]",
            end='')

        if (not exit_codition is None):
            if (abs(model.alpha.item()) > exit_codition and abs(model.delta.item()) > exit_codition):
                print("\n\nalpha and delta growing too big, choose different regularisation parameters.\n\n")
                break

    return model, model.state_dict()


def demo(picture, points):
    plt.imshow(picture)
    plt.scatter(points[:, 0], points[:, 1])
    plt.xticks([])
    plt.yticks([])
    plt.savefig("./Results/part_4_initial_face.png")
    plt.show()


def denormalize(points, picture, model):  # TODO
    return points


def main_4():
    data_manager = DataManager("./Results/")

    # extract
    picture = plt.imread("./Data/trump.jpg")
    points = extract_ground_truth(picture)

    # 4.1 show ground truth points
    demo(picture, points)

    # 4.2 training on face
    model, state = train(torch.LongTensor(points), lr=0.15, steps=500)
    somepoints = model.forward(None)
    actual_points = denormalize(somepoints.detach().cpu().numpy(), picture, model)
    demo(picture, actual_points)

    # 4.3 hyperparameter tuning

    result_dictionary = {}

    for alpha_reg in [0.1, 1, 10, 100, 1000, 1000]:
        for delta_reg in [0.1, 1, 10, 100, 1000, 10000]:
            print(f"TESTING: alpha_reg = {alpha_reg} and delta_reg = {delta_reg}")

            results = train(torch.LongTensor(points), lr=0.1, exit_codition=3.5)[1]
            result_dictionary[(alpha_reg, delta_reg)] = (results)
            data_manager.save_python_obj(result_dictionary, f"{data_manager.date_stamp()}__Grid_search_part4")


if __name__ == '__main__':
    ensure_current_directory()
    main_4()
