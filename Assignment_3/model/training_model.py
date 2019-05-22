import torch
import torch.nn


class Training(torch.nn.Module):
    def __init__(self, alpha_shape, delta_shape):
        super().__init__()

        device = torch.device('cuda' if torch.cuda.is_available() else 'cpu')

        self.alphas = (torch.randn(alpha_shape, requires_grad=True)).to(device)
        self.omegas = (torch.randn([0, 0.1745, 0], requires_grad=True)).to(device)
        self.tau = (torch.randn([0, 0, -400], requires_grad=True)).to(device)
        self.deltas = (torch.randn(delta_shape, requires_grad=True)).to(device)

    def forward(self, input):
        pass
