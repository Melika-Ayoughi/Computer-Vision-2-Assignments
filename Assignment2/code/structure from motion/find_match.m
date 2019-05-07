function [matches] = find_match(s, model)	
matches = zeros(3, size(s,2));

for i = 1:size(s,2)
    distance = inf;
    matched_point = zeros(3,1);
    for j = 1:size(model,2)
        new_distance = sqrt(sum(power(s(:,i)- model(:,j),2)));
        if (distance > new_distance)
            matched_point = model(:,j);
            distance = new_distance;
        end
    end
    matches(:,i) = matched_point;
end

end

