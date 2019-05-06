function [] = visualize_PV(PV) 

%get x and y aspect ratios
[y, x] = size(PV);

%make present points black and absent points white (in diagram)
binary_PV = PV == 0; 

%get indexes discarding the y's (not needed since binary)
idx = 1 + linspace(0,size(PV,1)-2,(size(PV,1)-2)/2+1);

binary_PV = binary_PV(idx,:);



figure();
imshow(binary_PV,'InitialMagnification','fit')
title('Number of 3D points: ' + string(size(PV,2)));
xlabel('Points') 
ylabel('Image Index') 
daspect([x y 1]) %correct aspect ratio
