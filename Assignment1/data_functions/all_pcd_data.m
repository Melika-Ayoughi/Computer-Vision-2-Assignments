function [pcds] = all_pcd_data()
% puts all 100 pictures in a struct

pcds = struct();
for ind = 1:100
    substruct = get_specific_pcd_data(ind);
    pcds.("num"+string(ind)) = substruct;
end

end