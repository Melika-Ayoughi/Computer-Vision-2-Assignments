function [transformed_source] = add_instability(source, R, t)
%ADD_INSTABILITY add rotation and translation to the source cloud points
transformed_source = R * source + t; 
end

