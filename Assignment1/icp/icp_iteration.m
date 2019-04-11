function [R, t] = icp_iteration(A_1, A_2, R, t)

% TO DO: implement

centroid_1 = centroid(A_1);
centroid_2 = centroid(A_2);

centered_vectors_1 = A_1 - t;
centered_vectors_2 = A_2 - t;

covariance = cov(centered_vectors_1, centered_vectors_2);

t = centroid_2 - R * centroid_1;

R = svd(covariance);

end