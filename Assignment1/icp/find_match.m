function [matches] = find_match(A1, A2, R, t)
%closest point is the point with lowest sum of squared errors
transformed_A1 = R* A1 + t;
matches = zeros(6, size(A1,2));

for i = 1:size(transformed_A1,2)
    distance = inf;
    matched_point = zeros(3,1);
    for j = 1:size(A2,2)
        new_distance = sum(power(transformed_A1(:,i)- A2(:,j),2));
        if (distance > new_distance)
            matched_point = A2(:,j);
            distance = new_distance;
        end
    end
    matches(:,i) = [A1(:,i);matched_point]; %A1 or transformed_A1
end

end

