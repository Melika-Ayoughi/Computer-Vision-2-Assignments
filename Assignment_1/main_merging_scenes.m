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
method = "informed_iterative_subsamp";
epsilon = 0.005;
sample_percentage = 0.1;
s_rate = 1;
N = 100; %Total number of images


%Get figure illustrating merging of 2 (consecutive) frames
[m1,m1_normals] = merge_scene(f1,f2, epsilon, method, sample_percentage, f1_normals, f2_normals, s_rate, idx, true, 1);


%Get point cloud and normals of last frame
idx = 100;
c_target = get_specific_pcd_data(idx);
current_target = c_target.pcd;
current_target_normals = c_target.normals;

%Get parameters for all transformations
params = [];
while idx - 1 ~= 0
    idx = idx - 1;
    disp('  ')
    disp('Getting parameters for frame ' + string(100-idx))
    disp('  ')
    c_base = get_specific_pcd_data(idx);
    current_base = c_base.pcd;
    current_base_normals = c_base.normals;
    
    [R, t, ~, ~] = icp(current_base,current_target, epsilon, method, sample_percentage, current_base_normals, current_target_normals);
    
    if idx ~= 99
        R = R*params(100-idx);
        t = R*params(99-idx) + t;
    end
    
    params = [params,R,t];
end

%Get transformation of 1st frame
f1 = get_specific_pcd_data(1);
merged = [params(1)*f1.pcd + params(2)];

%Perform all transformations and merge point clouds   
for i= 1:99
    disp('Merging frame ' + string(i));
    fi = get_specific_pcd_data(i+1);
    merged = [merged, params(2+i)*fi.pcd + params(3+i)];
end
    
    
% %Plot merged scene
% 
figure(6)

X = merged(1,:);
Y = merged(2,:);
Z = merged(3,:);

axis equal
scatter3(X,Y,Z, 1, 'blue', 'filled');
axis equal   

t6 = sgtitle('Merged point-clouds of all frames');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Q3.1 (b)

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

t2 = sgtitle('Merged point-clouds of the 10 first frames');


%Set sampling rate%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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



%Set sampling rate%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
s_rate = 4;

%Get final merged point clouds
[f_pc, ~] =  iterative_merging(epsilon, method, sample_percentage, s_rate,N);


%Plot merged scene

figure(4)

X = f_pc(1,:);
Y = f_pc(2,:);
Z = f_pc(3,:);

axis equal
scatter3(X,Y,Z, 1, 'blue', 'filled');
axis equal   

t4 = sgtitle('Merged point-clouds using frame sampling rate = ' + string(s_rate));
    
%Set sampling rate%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
s_rate = 10;

%Get final merged point clouds
[f_pc, ~] =  iterative_merging(epsilon, method, sample_percentage, s_rate,N);

%Plot merged scene

figure(5)

X = f_pc(1,:);
Y = f_pc(2,:);
Z = f_pc(3,:);

axis equal
scatter3(X,Y,Z, 1, 'blue', 'filled');
axis equal   

t5 = sgtitle('Merged point-clouds using frame sampling rate = ' + string(s_rate));

