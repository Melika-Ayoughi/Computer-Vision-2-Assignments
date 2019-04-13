

% 3 * 6400 double
load('../Data/source.mat')
load('../Data/target.mat')

dimensions = 3;  
[R, t] = icp(source, target, dimensions);

d = R*source +t;

scatter3(source(1,:),source(2,:),source(3,:),'red');hold;
scatter3(target(1,:),target(2,:),target(3,:),'blue');hold;
% scatter3(d(1,:),d(2,:),d(3,:),'green');hold;