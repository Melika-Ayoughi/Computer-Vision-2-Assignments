function[f1f2, f1f2_normals] = merge_scene(f1, f2, eps, method, sample_percentage, f1_normals, f2_normals, step, idx, plot)
 % MERGE_SCENE		 [add function description here]
 % INPUTS 
 %			f1 = ..
 %			f2 = ..
 %			eps = ..
 %			method = ..
 %			sample_percentage = ..
 %			f1_normals = ..
 %			f2_normals = ..
 %			step = ..
 %			idx = ..
 % OUTPUTS 
 %			f1f2 = ..
 %			f1f2_normals = ..


% disp('idx = ' + string(idx))
% disp('step = ' + string(step))

%Get frame at previous step
previous_f = get_specific_pcd_data(idx - step);
p_f = previous_f.pcd;
p_f_normals = previous_f.normals;

%Get transformation between f2 and previous step
[R, t, ~, ~] = icp(p_f,f2, eps, method, sample_percentage, p_f_normals, f2_normals);

%Get transformed f1 point cloud
t_f1 = R*f1 + t;

%Translate f1 and merge with f2 along the column axis
f1f2 = [t_f1, f2];
f1f2_normals = [R*f1_normals, f2_normals];

    
%Visualize merging
if plot == true
    
    f1 = figure();

    X1 = t_f1(1,:);
    Y1 = t_f1(2,:);
    Z1 = t_f1(3,:);
    
    X2 = f2(1,:);
    Y2 = f2(2,:);
    Z2 = f2(3,:);    

    axis equal
    scatter3(X1,Y1,Z1, 1, 'red', 'filled');
    axis equal
    hold on
    axis equal
    scatter3(X2,Y2,Z2, 1, 'blue', 'filled');
    axis equal
    
    t1 = sgtitle('Merged point-clouds of two frames');

%     saveas(gcf,get_path("results") + 'F1.png');
end
