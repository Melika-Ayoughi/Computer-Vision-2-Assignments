from utils.util_functions import *
import matplotlib.pylab as plt
import torch
from model.training_model import Training
from model.data_management import DataManager
from part_4.landmarks import *
from part_4.plotter import plot_mesh

pdist = torch.nn.PairwiseDistance(p=2)

def loss_total(alpha, delta, p, ground_truth, lambda_alpha=1.0, lambda_delta=1.0):
    """
    Combined loss function

    :param alpha:
    :param delta:
    :param p:
    :param ground_truth:
    :param lambda_alpha:
    :param lambda_delta:
    :return:
    """
    loss_lan = torch.sum(pdist(p, ground_truth) ** 2)

    loss_reg = loss_reg_function(lambda_alpha, lambda_delta, alpha, delta)

    return loss_reg + loss_lan


def loss_reg_function(lambda_alpha, lambda_delta, alpha, delta):
    """
    regulariser part of loss function

    :param lambda_alpha:
    :param lambda_delta:
    :param alpha:
    :param delta:
    :return:
    """
    return lambda_alpha * torch.sum(alpha.pow(2)) + lambda_delta * torch.sum(delta.pow(2))


def extract_ground_truth(face, normalised=False):
    """
    get ground truth landmarks (normalised or not

    :param face:
    :param normalised:
    :return:
    """

    points = np.array(detect_landmark(face))

    x_column = points[:, 0]
    y_column = points[:, 1]

    if (normalised):
        x_max = face.shape[1]
        y_max = face.shape[0]
    else:
        x_max, y_max = 1, 1

    x_scaled = x_column / x_max
    y_scaled = y_column / y_max

    out = np.stack((x_scaled, y_scaled), 1)

    return out


def demo_train(train_points, ground_truth):
    """
    plots progress of training

    :param train_points:
    :param ground_truth:
    :return:
    """
    ranger = [5]  # trackable point on both faces
    plt.scatter(train_points[:, 0], -1 * train_points[:, 1])
    plt.scatter(ground_truth[:, 0], -1 * ground_truth[:, 1])
    plt.scatter(train_points[ranger, 0], -1 * train_points[ranger, 1], color="r")
    plt.scatter(ground_truth[ranger, 0], -1 * ground_truth[ranger, 1], color="g")

    plt.xticks([])
    plt.yticks([])
    plt.savefig("./Results/part_4_debug.png")
    plt.show()
    plt.clf()


def train(ground_truth, lambda_alpha=1.0, lambda_delta=1.0, lr=0.001, steps=2000, exit_codition=None, picture=None,
          normalised=False):
    """
    trains model

    :param ground_truth:
    :param lambda_alpha:
    :param lambda_delta:
    :param lr:
    :param steps:
    :param exit_codition:
    :param picture:
    :param normalised:
    :return:
    """

    device = torch.device('cuda' if torch.cuda.is_available() else 'cpu')

    model = Training(picture, normalised=normalised)

    model.to(device)

    opt = torch.optim.Adam(model.parameters(), lr=lr)

    ground_truth = torchify([ground_truth.numpy()])[0]

    losses = []

    for i in range(steps):
        opt.zero_grad()

        p = model.forward(None)

        loss = loss_total(model.alpha, model.delta, p, ground_truth, lambda_alpha=lambda_alpha,
                          lambda_delta=lambda_delta)

        loss.backward()

        opt.step()

        losses.append(loss.item())

        loss.detach()

        print(
            f"\rEpoch: {i}, Loss: {loss.item():0.3f} alpha: {model.alpha.item():0.5f}, delta: {model.delta.item():0.5f}, omega: [{model.omega[0].item():0.5f}, {model.omega[1].item():0.5f}, {model.omega[2].item():0.5f}], tau [{model.tau[0].item():0.5f}, {model.tau[1].item():0.5f}, {model.tau[2].item():0.5f}]",
            end='')

        if (i % 100 == 0 and not picture is None):
            normalised_points = model.forward(None)
            train_points = denormalize(normalised_points.detach().cpu().numpy(), picture, normalised=normalised)
            ground_truth_detached = denormalize(ground_truth.detach().cpu().numpy(), picture, normalised=normalised)
            demo_train(train_points, ground_truth_detached)

        if (not exit_codition is None):
            if (abs(model.alpha.item()) > exit_codition and abs(model.delta.item()) > exit_codition):
                print("\n\nalpha and delta growing too big, choose different regularisation parameters.\n\n")
                break

    torch.save(model, "Results/model.pt")

    return model, model.state_dict(), losses


def demo(picture, points):
    """ plots points on top of picture """

    plt.imshow(picture)
    plt.scatter(points[:, 0], points[:, 1])
    plt.xticks([])
    plt.yticks([])
    plt.savefig("./Results/part_4_initial_face.png")
    plt.show()


def denormalize(points, picture, normalised=False):
    """ denormalized if there was normalised to begin with """

    # get ratio
    shape = picture.shape[:-1][::-1]

    # denormalise if normalised=True
    return (points * shape * int(normalised)) + (points * int(not normalised))


def main_4(normalised=False):
    """ does all experiments of part 4 of the assignment """

    data_manager = DataManager("./Results/")

    # extract
    picture = plt.imread("./Data/sjors2.jpg")[:, :, :3]
    ground_truth_points = extract_ground_truth(picture, normalised=normalised)

    """ ############ 4.1 show ground truth points ############ """

    print("Start part 1")

    demo(picture, denormalize(ground_truth_points, picture))

    """ ############ 4.2 training on face ############ """

    print("Start part 2")

    model, state, losses = train(torch.FloatTensor(ground_truth_points), lr=0.175, steps=1000, lambda_alpha=10000,
                                 lambda_delta=10000, picture=picture, normalised=normalised)

    normalised_points = model.forward(None)
    actual_points = denormalize(normalised_points.detach().cpu().numpy(), picture, normalised=normalised)
    demo(picture, actual_points)

    """ ############ 4.3 hyperparameter tuning ############ """

    print("Start part 3")

    result_dictionary = {}

    stamp = data_manager.date_stamp()

    testrange = [0.1, 1, 10, 100, 1000, 10000]

    for alpha_reg in testrange:

        for delta_reg in testrange:
            print(f"TESTING: alpha_reg = {alpha_reg} and delta_reg = {delta_reg}")

            results = train(torch.LongTensor(ground_truth_points), lr=0.175, exit_codition=3.5, steps=500,
                            picture=picture, lambda_alpha=alpha_reg, lambda_delta=delta_reg, normalised=normalised)[1:3]
            result_dictionary[(alpha_reg, delta_reg)] = (results)
            data_manager.save_python_obj(result_dictionary, f"{stamp}_Grid_search_part4")

    data = data_manager.load_python_obj(f"{stamp}_Grid_search_part4")
    plot_mesh(data)

    return


if __name__ == '__main__':
    ensure_current_directory()

    main_4()
