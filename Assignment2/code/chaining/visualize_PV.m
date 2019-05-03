function [] = visualize_PV(PV) %%%%%%%%%%%STILL WORKING ON THIS

[h,w] = size(PV);

binary_mat = compute_connections(PV);

keep_columns = false(1,w);
for ii = 1:w
    if sum(binary_mat(:,ii)) > 10 %min no. of elements
        keep_columns(ii) = true;
    end
end

end



function [connections] = compute_connections(PV)

[m, n] = size(PV);
assert (mod(m, 2) == 0);
m = m / 2;


connections = false(m, n);

for i =1:n
    for j =1:m
        if ~any(isnan(PV(2*(j-1)+1:2*(j-1)+2, i)))
            connections(j, i) = true;
        end
    end
end

figure();
imshow(-1*(connections -1),'InitialMagnification','fit');
title(sprintf('Number of feature points:%d',size(PV,2)));
daspect([n,m,1]);
pause(0.5);

end