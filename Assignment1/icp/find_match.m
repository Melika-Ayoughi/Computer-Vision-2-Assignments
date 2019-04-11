function [matches] = find_match(A1, A2, R, t)
transformed_A1 = R* A1 + t;
matches = zeros(6, size(A1,2));

 for i = size(transformed_A1,2)
     distance = inf;
     matched_point = zeros(3,1);
     for j = size(A2,2)
         new_distance = abs(transformed_A1(:,i)- A2(:,j));
        if (distance > new_distance)
            matched_point = A2(:,j);
            distance = new_distance;
        end
     end
     matches (:,i) = [A1(:,i);A2(:,j)];
end

