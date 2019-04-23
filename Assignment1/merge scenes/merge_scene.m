function[f1f2, f1f2_normals] = merge_scene(f1, f2, eps, method, sample_percentage, f1_normals, f2_normals)

% merge_scene(frames, frames_normals, rate, iterative_merge, reference, sampling, selection, matching, rejection, weighting, plot, name)

%Get two consecutive frames of the given data

%get R and t (define camera movement between A1 (base point cloud) and A2
%(target point cloud))
%Using the estimated camera poses, merge the point-clouds of all the scenes into one point-cloud
%Visualize the result

%Get transformation between f1 and f2
[R, t, ~, ~] = icp(f1,f2, eps, method, sample_percentage, f1_normals, f2_normals);

%Translate f1 and merge with f2 along the column axis
f1f2 = [R*f1 + t, f2];
f1f2_normals = [R*f1_normals, f2_normals];

% %Plot merged scene
% X = f1f2(1,:);
% Y = f1f2(2,:);
% Z = f1f2(3,:);
% 
% axis equal
% scatter3(X,Y,Z, 1, color, 'filled');
% axis equal



