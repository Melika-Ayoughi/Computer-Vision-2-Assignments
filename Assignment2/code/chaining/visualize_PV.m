function [] = visualize_PV(PV) 

binary_PV = PV > 0;

imshow(binary_PV)