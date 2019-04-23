function[f1f2, f1f2_normals] = merge_scene(f1, f2, eps, method, sample_percentage, f1_normals, f2_normals, step, idx)	 % DOCSTRING_GENERATED
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



% merge_scene(frames, frames_normals, rate, iterative_merge, reference, sampling, selection, matching, rejection, weighting, plot, name)

%Get two consecutive frames of the given data

%get R and t (define camera movement between A1 (base point cloud) and A2
%(target point cloud))
%Using the estimated camera poses, merge the point-clouds of all the scenes into one point-cloud
%Visualize the result

if step == 1
    %Get transformation between f1 and f2
    [R, t, ~, ~] = icp(f1,f2, eps, method, sample_percentage, f1_normals, f2_normals);

    %Translate f1 and merge with f2 along the column axis
    f1f2 = [R*f1 + t, f2];
    f1f2_normals = [R*f1_normals, f2_normals];
    
else
    
    %Get frame at previous step
    previous_f = get_specific_pcd_data(idx - step);
    p_f = previous_f.pcd;
    p_f_normals = previous_f.normals;
    
    %Get transformation between f2 and previous step
    [R, t, ~, ~] = icp(p_f,f2, eps, method, sample_percentage, p_f_normals, f2_normals);

    %Translate f1 and merge with f2 along the column axis
    f1f2 = [R*f1 + t, f2];
    f1f2_normals = [R*f1_normals, f2_normals];


end