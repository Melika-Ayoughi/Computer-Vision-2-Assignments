function T = T_matrix(d, m_X, m_Y)	 % DOCSTRING_GENERATED
 % T_MATRIX		 [Sets up T matrix according to assignment description]
 % INPUTS 
 %			d = ..
 %			m_X = ..
 %			m_Y = ..
 % OUTPUTS 
 %			T = ..


% get constant
sq_2 = sqrt(2);

% multiply with d
c = sq_2/d;

% form matrix
T = [c,0,-m_X*c;
    0, c, -m_Y*c;
    0,0,1];

end