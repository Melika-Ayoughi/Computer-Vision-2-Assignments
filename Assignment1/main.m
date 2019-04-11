
% load data
% 3 * 6400 double
load('./Data/source.mat')
load('./Data/target.mat')

dimensions = 0 ; % todo

[R, t] = icp(A_1, A_2);