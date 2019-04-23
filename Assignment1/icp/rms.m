function error = rms(A1, A2, R, t)	 % DOCSTRING_GENERATED
 % RMS		 [RMS score function]
 % INPUTS 
 %			A1 = set 1
 %			A2 = set 2
 %			R = ..
 %			t = ..
 % OUTPUTS 
 %			error = returned error



transformed_A1 = R* A1 + t;
error = sqrt(sum(power(transformed_A1 - A2,2))/size(A1,2));

end