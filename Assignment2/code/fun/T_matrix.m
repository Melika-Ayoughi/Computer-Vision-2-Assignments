function T = T_matrix(d, m_X, m_Y)

sq_2 = sqrt(2);

c = sq_2/d;

T = [c,0,-m_X*c;
    0, c, -m_Y*c;
    0,0,1];

end