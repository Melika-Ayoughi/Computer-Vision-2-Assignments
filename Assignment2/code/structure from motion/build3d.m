function [] = build3d(PV, seq, mode, eliminate_affine)	 % DOCSTRING_GENERATED
 % BUILD3D		 
 % structure from motion
 
 % INPUTS 
 %			PV =  point view matrix : 2M*N (M=#images N=#points)
 %			seq = number of images that we take as a sequence
 % OUTPUTS 
 %			 = ..

model = zeros(3, size(PV,2));
old_points_idx = false(1, size(PV,2));

step = 2 * seq;
for image= 1 : step : size(PV,1)-step+1
    
    dense_points_idx = all(PV(image:image+step-1, :));
    PV_dense = PV(image:image+step-1, dense_points_idx);
    
    [s, ~] = calculate_s_m(PV_dense, 1);
    
    points = zeros(3, size(PV,2));
    points(:, dense_points_idx) = s;
    
    if image==1
        model(:, dense_points_idx) = s;
    else
        intersect_idx =  old_points_idx & dense_points_idx;
        [~,Z,transform] = procrustes(model(:, intersect_idx)', points(:, intersect_idx)');
        
        %update old points in model with newer iterations
        model(:, intersect_idx) = Z';
        
        % for all points that are new 
        % add those points to the model
        if ~isempty(points(:, dense_points_idx & ~intersect_idx))  
            model(:, dense_points_idx & ~intersect_idx) = (transform.b * points(:, dense_points_idx & ~intersect_idx)' * transform.T + transform.c(1,:))';
        end
    end
    old_points_idx = old_points_idx | dense_points_idx;
end

% visualize cloud points
figure(5);
scatter3(model(1,:), model(2,:), model(3,:)) %maybe some prettier function
    

end

