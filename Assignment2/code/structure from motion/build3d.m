function [] = build3d(PV, seq)	 % DOCSTRING_GENERATED
 % BUILD3D		 
 % structure from motion
 
 % INPUTS 
 %			PV =  point view matrix : 2M*N (M=#images N=#points)
 %			seq = number of images that we take as a sequence
 % OUTPUTS 
 %			 = ..




step = 2 * seq;
for image= 1 : step : size(PV,1)-step+1
    PV_dense = PV(image:image+step-1, all(PV(image:image+step-1, :)));
    size(PV_dense)
    [s, m] = calculate_s_m(PV_dense, 1);
    
    if image==1
        model = s;
    else
        model = [model,s];
%         match_points(s, model);
    end
        
    figure(4);
    scatter3(model(1,:), model(2,:), model(3,:)) %maybe some prettier function
end

% Eliminate affine ambiguity

end

