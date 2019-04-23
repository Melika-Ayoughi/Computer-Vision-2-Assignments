function [current_f, current_f_normals] = iterative_merging(current_f, epsilon, method, sample_percentage, current_f_normals, step, N)
 % MERGE_SCENE		 [Iterates through frames according to specified sampling step size and merges all frames]
 % INPUTS 
 %			current_f = starting base frame point cloud
 %			epsilon = threshold for ICP
 %			method = sampling method
 %			sample_percentage = ..
 %			current_f_normals = starting base frame normals
 %			step = sampling step size
 %			idx = index of target frame
 % OUTPUTS 
 %			current_f = point cloud of all merged frames
 %			current_f_normals = normals of all merged frames
 
 
%Index of first base frame
idx = 1;

% %make frame dictionary
% l_struct = struct(); 

while idx + step <  N
    
    %Get current target frame index
    idx = idx + step;  
    
    %Get current target frame's point cloud and normals
    next_f = get_specific_pcd_data(idx);
    n_f = next_f.pcd;
    n_f_normals = next_f.normals;

    disp(' ')
    disp('Current target frame: Frame ' + string(idx));
    disp('------------------------')
    
    %Get merged frames
    [m,m_normals] = merge_scene(current_f,n_f, epsilon, method, sample_percentage, current_f_normals, n_f_normals, step, idx, false);
    
    disp(' ')
    
%     str1 = 'm' + string(idx - s_rate);
%     str2 = 'm' + string(idx - s_rate) + '_normals';
%     
%     %Add merged pc to struct
%     l_struct.(str1) = m;r
%     l_struct.(str2) = m_normals;

    %Assign merged frames to current frame
    current_f = m;
    current_f_normals = m_normals;
    
    
end