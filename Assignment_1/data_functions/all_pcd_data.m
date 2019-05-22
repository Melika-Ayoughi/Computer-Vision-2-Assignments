function [pcds] = all_pcd_data()	 % DOCSTRING_GENERATED
 % ALL_PCD_DATA		 [add function description here]
 % INPUTS 
 % OUTPUTS 
 %			pcds = ..


% puts all 100 pictures in a struct

pcds = struct();
for ind = 1:100
    substruct = get_specific_pcd_data(ind);
    pcds.("num"+string(ind)) = substruct;
end

end