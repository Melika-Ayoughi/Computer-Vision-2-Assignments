function [R, t] = icp_iteration(A_1, A_2)

centroid_1 = mean(A_1,2);
centroid_2 = mean(A_2,2);

centered_vectors_1 = A_1 - centroid_1;
centered_vectors_2 = A_2 - centroid_2;

% covariance = cov(centered_vectors_1, centered_vectors_2);
S = centered_vectors_1 * centered_vectors_2';
[U,~,V] = svd(S);
middle = eye(size(V,2));
middle(end) = det(V*U');

R = V * middle * U';
t = centroid_2 - R * centroid_1;
end