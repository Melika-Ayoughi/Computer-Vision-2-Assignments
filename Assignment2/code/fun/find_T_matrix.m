function [T_1, T_2] = find_T_matrix(matches, frame_1, frame_2)


p_1 = [];
p_2 = [];

for i = 1:size(matches,2)
    match_index_1 = matches(1, i);
    match_index_2 = matches(2, i);
    
    x_1 = frame_1(1, match_index_1);
    y_1 = frame_1(2, match_index_1);
    x_2 = frame_2(1, match_index_2);
    y_2 = frame_2(2, match_index_2);
    
    p_1 = [p_1; [x_1,y_1]];
    p_2 = [p_2; [x_2,y_2]];
end

ms_1 = mean(p_1, 1);
ms_2 = mean(p_2, 1);

d_1 = mean(sum(sqrt((p_1-ms_1).^2), 2));
d_2 = mean(sum(sqrt((p_2-ms_2).^2), 2));

T_1 = T_matrix(d_1, ms_1(1), ms_1(2));
T_2 = T_matrix(d_2, ms_2(1), ms_2(2));

end




