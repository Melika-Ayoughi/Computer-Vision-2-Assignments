
% load data
% 3 * 6400 double
load('./Data/source.mat')
load('./Data/target.mat')

dimensions = 3;  
[R, t] = icp(source, target, dimensions);