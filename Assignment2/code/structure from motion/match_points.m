function [model] = match_points(s, model)
%MATCH_POINTS of s and the 3d model
% find the closest points to s -> they are old points
s_ = find_match(s, model); %s_ old points
[d,Z,transform] = procrustes(s, s_);
new_points = setdiff(model', (transform.b * s_ * transform.T + transform.c)', 'rows');
model = [model, new_points' ];
end

