function [transformed_source] = add_instability(source, R, t)	 % DOCSTRING_GENERATED
 % ADD_INSTABILITY		 [adds instability to source point cloud]
 % INPUTS 
 %			source = ..
 %			R = ..
 %			t = ..
 % OUTPUTS 
 %			transformed_source = ..


%ADD_INSTABILITY add rotation and translation to the source cloud points

transformed_source = R * source + t; 

end

