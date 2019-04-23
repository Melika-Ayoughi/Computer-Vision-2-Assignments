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
method = "all_points";
epsilon = 0.0055;
sample_percentage = 0.1;

[m1,m1_normals] = merge_scene(f1,f2, epsilon, method, sample_percentage, f1_normals, f2_normals);


%Plot merged scene
X = m1(1,:);
Y = m1(2,:);
Z = m1(3,:);

axis equal
scatter3(X,Y,Z, 1, color, 'filled');
axis equal

%Q3.1 (b)

%Set sampling rate
s_rate = 2;

%get first frame index
f = idx;

%total number of frames
N = 100;

%make frame dictionary
l_struct = struct();

while (f + s_rate) <  N:
    
    
    
    [m,m_normals] = merge_scene(f1,f2, epsilon, method, sample_percentage, f1_normals, f2_normals);
    
    str1 = 'm' + f;
    str2 = 'm' + f + '_normals';
    
    %Add merged pc to struct
    l_struct.(str1) = m;
    l_struct.(str2) = m_normals;
    
    f+s_rate;
end
    
    
    
    



