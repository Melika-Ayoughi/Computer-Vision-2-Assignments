function [PV] = get_point_view_matrix(imgs, s_threshold, m_threshold,distance, ransac)	 % DOCSTRING_GENERATED
 % GET_POINT_VIEW_MATRIX		 [retrieves the pvm]
 % INPUTS 
 %			imgs = all images
 %			s_threshold = threshold for sift extraction
 %			m_threshold = threshold for matching descriptors
 % OUTPUTS 
 %			PV = point view matrix



%get first image
img_1 = imgs(1,:,:);

% find points
[f_1,d_1] = vl_sift(single(reshape(img_1, 480, 512)),'PeakThresh', s_threshold) ;
previous_d = d_1;
previous_f = f_1;


%initialize dictionary
dict = struct;
dict.f1 = f_1;
dict.d1 = d_1;

%initialize PV (rows = 2*images, columns = no. of surface points)
PV = zeros(2*size(imgs,1), size(f_1,2));

%Add x and y coordinates of points
PV(1:2,:) = f_1(1:2,:);

for i = 2:size(imgs,1)
    
    disp('  ')
    disp('Current img: ' + string(i) + '/' + string(size(imgs,1)))
    disp('  ')
    
    %get points in current image
    current_img = imgs(i, :, :);
    [current_f, current_d] = vl_sift(single(reshape(current_img, 480, 512)),'PeakThresh', s_threshold);
%     previous_f = dict.('f' + string(i-1));
    
    %add current frames and descriptors to dict
    dict.('f'+string(i)) = current_f;
    dict.('d'+string(i)) = current_d;
    
    %get matching points in current and previous img (match row 1 = idx in
    %f_1, row 2 = idx in f_2)
    [matches, scores] = vl_ubcmatch(previous_d, current_d, m_threshold); 

    if distance == 1
    %     %use L2 distance to filter matches
        best_idx = find(scores < 5000);
        matches = matches(:,best_idx);
    end

    if ransac == 1
        %extract best matches using RANSAC
        n_matches = floor(size(matches,2)/2);
        n_matches = 8; 
        [~, ~, ~, best_idx] = get_fun_RANSAC(matches, previous_f, current_f, 1, n_matches , 1000);
        matches = matches(:,best_idx);
    end
    
    %get current image row idxs
    idx = [(i*2)-1,(i*2)];
    
    %add coordinates of matching points to PV matrix
    PV((idx),matches(1,:)) = current_f(1:2,matches(2,:));
    
    %add new points to PV matrix
    new_point_idx = setdiff(1:size(current_f, 2),matches(2,:)); %get indexes of points in current img not in PV
    new_PV = zeros(2*size(imgs,1), size(new_point_idx,2));%initialize new columns for new points
    new_PV(idx,:) = current_f(1:2,new_point_idx);%add coordinates of new points to new PV columns
    
   
%     %check previous images for matching points
%     for p = 1:(i-1)
%        
%        p_f = dict.('f' + string(p));
%        p_d = dict.('d' + string(p));
% 
%        %get matches with new points
%        [matches, ~] = vl_ubcmatch(p_d, current_d(:,p_new),m_threshold);
%        
%        %get img row idx
%        p_idx = [(p*2)-1,(p*2)];
%        
%        %add coordinates of new points in image row
%        new_PV(p_idx,matches(2,:)) = p_f(1:2,matches(1,:));
%     end
    
%     %increment previous d with new points encountered
    previous_d = [previous_d, current_d(:,new_point_idx)]; 
    previous_f = [previous_f, current_f(:,new_point_idx)]; 
    
    %Add new point columns to PV
    PV = [PV, new_PV];
    
end   

end
   
    
    
    