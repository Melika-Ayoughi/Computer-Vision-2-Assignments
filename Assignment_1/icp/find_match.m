function [matches] = find_match(A1, A2)	 % DOCSTRING_GENERATED
 % FIND_MATCH		 [finds best match given two point clouds]
 % INPUTS 
 %			A1 = ..
 %			A2 = ..
 % OUTPUTS 
 %			matches = ..


matches = zeros(6, size(A1,2));

for i = 1:size(A1,2)
    distance = inf;
    matched_point = zeros(3,1);
    for j = 1:size(A2,2)
        new_distance = sqrt(sum(power(A1(:,i)- A2(:,j),2)));
        if (distance > new_distance)
            matched_point = A2(:,j);
            distance = new_distance;
        end
    end
    matches(:,i) = [A1(:,i);matched_point];
end

end

