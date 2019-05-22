function [] = visualize_PV(img_1, PV, density) 	 % DOCSTRING_GENERATED
 % VISUALIZE_PV		 [Binarizes the PV matrix and outputs a sparsity plot]
 % INPUTS 
 %			PV = The point view matrix
 % OUTPUTS 
 %			 = Sparsity visualisation



%get x and y aspect ratios
[y, x] = size(PV);

%make present points black and absent points white (in diagram)
binary_PV = PV == 0; 

%get indexes discarding the y's (not needed since binary)
idx = 1 + linspace(0,size(PV,1)-2,(size(PV,1)-2)/2+1);

binary_PV = binary_PV(idx,:);


fig1 = figure();
imshow(binary_PV,'InitialMagnification','fit')
title('Number of 3D points: ' + string(size(PV,2)));
xlabel('Points') 
ylabel('Image Index') 
daspect([x y 1]) %correct aspect ratio
saveas(fig1, strcat('PV_',density,'.png'));

fig2 = figure();
imshow(im2double(mat2gray(reshape(img_1, 480, 512))));
% title('Trace of point view matrix');
hold on
plot(PV(1:2:end,:),PV(2:2:end,:) , '.', 'MarkerSize',5);
saveas(fig2, strcat('trace_', density, '.png'));

