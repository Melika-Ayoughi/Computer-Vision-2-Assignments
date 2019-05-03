function [] = visualize_PV(PV) 


binary_PV = PV > 0;

%get indexes discarding the y's (not needed since binary
idx = 1 + linspace(0,size(PV,1)-2,(size(PV,1)-2)/2+1);

binary_PV = binary_PV(idx,:);

imshow(binary_PV)
