function [current_f, current_f_normals] = iterative_merging(current_f, epsilon, method, sample_percentage, current_f_normals, s_rate, N)

idx = 1;

% %make frame dictionary
% l_struct = struct();

while idx + s_rate <  N
    
    idx = idx +s_rate;
    
%     disp(' itmerge idx = ' + string(idx))
%     disp('itmerge step = ' + string(s_rate))    
    
    %Get next frame's point cloud and normals
    next_f = get_specific_pcd_data(idx);
    n_f = next_f.pcd;
    n_f_normals = next_f.normals;

    disp(' ')
    disp('Current target frame: Frame ' + string(idx));
    disp('------------------------')
    
    [m,m_normals] = merge_scene(current_f,n_f, epsilon, method, sample_percentage, current_f_normals, n_f_normals, s_rate, idx, false);
    
    disp(' ')
    
%     str1 = 'm' + string(idx - s_rate);
%     str2 = 'm' + string(idx - s_rate) + '_normals';
%     
%     %Add merged pc to struct
%     l_struct.(str1) = m;r
%     l_struct.(str2) = m_normals;

    current_f = m;
    current_f_normals = m_normals;
    
    
end