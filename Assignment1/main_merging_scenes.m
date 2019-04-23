%Q3.1 (a)

%get index of a random frame from given data
idx = 1;

%load 2 consecutive frames
frame1 = get_specific_pcd_data(idx);
frame2 = get_specific_pcd_data(idx+1);

f1 = frame1.pcd;
f2 = frame2.pcd;

f1_normals = frame1.normals;
f2_normals = frame2.normals;


%Parameters
method = "uniform_subsamp";
epsilon = 0.00025;
sample_percentage = 0.1;
s_rate = 1;

[m1,m1_normals] = merge_scene(f1,f2, epsilon, method, sample_percentage, f1_normals, f2_normals, s_rate, idx);


%Plot merged scene
figure(1)

X = m1(1,:);
Y = m1(2,:);
Z = m1(3,:);

axis equal
scatter3(X,Y,Z, 1, 'blue', 'filled');
axis equal

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Q3.1 (b)

%Get first frame point cliud and normals
current_f = f1;
current_f_normals = f1_normals;

%Set sampling rate
s_rate = 2;

%total number of frames
N = 10;

%make frame dictionary
l_struct = struct();

while idx <  N
    
    idx = idx +s_rate;
    
    %Get next frame's point cloud and normals
    next_f = get_specific_pcd_data(idx);
    n_f = next_f.pcd;
    n_f_normals = next_f.normals;

    [m,m_normals] = merge_scene(current_f,n_f, epsilon, method, sample_percentage, current_f_normals, n_f_normals, s_rate, idx);
    
%     str1 = 'm' + string(idx - s_rate);
%     str2 = 'm' + string(idx - s_rate) + '_normals';
%     
%     %Add merged pc to struct
%     l_struct.(str1) = m;
%     l_struct.(str2) = m_normals;

    current_f = m;
    current_f_normals = m_normals;
    
    
end


%Plot merged scene

figure(2)

X = current_f(1,:);
Y = current_f(2,:);
Z = current_f(3,:);

axis equal
scatter3(X,Y,Z, 1, 'blue', 'filled');
axis equal   
    
    
    



