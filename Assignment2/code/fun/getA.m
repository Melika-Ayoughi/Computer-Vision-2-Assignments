function A = getA(matches, frame_1, frame_2, method)

% init A
A = zeros(size(matches,2), 9);

% get T matrices if normalized
if (strcmp(method, "normalized"))

    [T_1, T_2] = find_T_matrix(matches, frame_1, frame_2);

end


for i = 1:size(matches,2)
    
    % find points from matches
    match_index_1 = matches(1, i);
    match_index_2 = matches(2, i); 
    x_1 = frame_1(1, match_index_1);
    y_1 = frame_1(2, match_index_1);
    x_2 = frame_2(1, match_index_2);
    y_2 = frame_2(2, match_index_2);
    
    % translate and rotate if needed
    if (strcmp(method, "normalized"))
        
       
        p_1 = T_1 * [x_1; y_1; 1]; % TODO: row or column vector?
        p_2 = T_2 * [x_2; y_2; 1];

        x_1 = p_1(1);
        x_2 = p_2(1);
        y_1 = p_1(2);
        y_2 = p_2(2);
        
    end
    
    % get A matrix entry
    A(i,:) = [x_1*x_2, x_1*y_2, x_1, y_1*x_2, y_1*y_2, y_1, x_2, y_2, 1];
    
end