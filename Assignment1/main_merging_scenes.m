%Q3.1 (a)

%get index of target frame
idx = 2;

%load 2 consecutive frames
frame1 = get_specific_pcd_data(idx-1);
frame2 = get_specific_pcd_data(idx);

%Get corresponding point clouds and normals
f1 = frame1.pcd;
f2 = frame2.pcd;
f1_normals = frame1.normals;
f2_normals = frame2.normals;


%Parameters
method = "uniform_subsamp";
epsilon = 0.00025;
sample_percentage = 0.5;
s_rate = 1;
N = 100; %Total number of images


%Get figure illustrating merging of 2 (consecutive) frames
[m1,m1_normals] = merge_scene(f1,f2, epsilon, method, sample_percentage, f1_normals, f2_normals, s_rate, idx, true);



%Get final merged point clouds
[f_pc, ~] =  iterative_merging(epsilon, method, sample_percentage, s_rate,N);


%Plot merged scene

figure(2)

X = f_pc(1,:);
Y = f_pc(2,:);
Z = f_pc(3,:);

axis equal
scatter3(X,Y,Z, 1, 'blue', 'filled');
axis equal   

t2 = sgtitle('Merged point-clouds of all the frames');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Q3.1 (b)


%Set sampling rate
s_rate = 2;

%Get final merged point clouds
[f_pc, ~] =  iterative_merging(epsilon, method, sample_percentage, s_rate,N);


%Plot merged scene

figure(3)

X = f_pc(1,:);
Y = f_pc(2,:);
Z = f_pc(3,:);

axis equal
scatter3(X,Y,Z, 1, 'blue', 'filled');
axis equal   

t3 = sgtitle('Merged point-clouds using frame sampling rate = ' + string(s_rate));
    
    



