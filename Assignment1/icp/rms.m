function error = rms(A1, A2, R, t)

% TO DO: implement
transformed_A1 = R* A1 + t;
error = sqrt(sum(power(transformed_A1 - A2,2))/size(A1,2));

end