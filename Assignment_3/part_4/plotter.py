import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D
import numpy as np
from model.data_management import DataManager


def plot_mesh(data):
    """
    plots mesh of part4 hyperparameter tuning

    :param data:
    :return:
    """

    fig = plt.figure()
    ax = fig.add_subplot(111, projection='3d')

    X = []
    Y = []
    Z = []

    for key, value in data.items():
        X.append(np.log10(key[0]))
        Y.append(np.log10(key[1]))
        Z.append(value[1][-1])

    X = np.array(X)
    Y = np.array(Y)
    Z = np.array(Z)

    plt.figure(figsize=(100, 100))

    ax.plot_surface(np.array(X).reshape((6, 6)), np.array(Y).reshape((6, 6)), np.array(Z).reshape((6, 6)))
    ax.plot_wireframe(np.array(X).reshape((6, 6)), np.array(Y).reshape((6, 6)), np.array(Z).reshape((6, 6)), color="")
    ax.set_xlabel('Alpha-hyper in log_10')
    ax.set_ylabel('Delta-hyper in log10')
    ax.set_title('Final loss of run')

    plt.show()
