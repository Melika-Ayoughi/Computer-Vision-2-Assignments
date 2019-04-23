function [filtered_matches] = filter_bad_points(matches, R, t)
%FILTER_BAD_POINTS Summary of this function goes here
%   Detailed explanation goes here
matches(1:3,:) = R * matches(1:3,:) + t;
filtered_matches = matches(:, mean(matches(1:3,:) - matches(4:6,:),1) < 0.01);
filtered_matches = filtered_matches(:, filtered_matches(3,:) < 2);
end

