function thresholding(picture, range)	 % DOCSTRING_GENERATED
 % THRESHOLDING		 [Does qualitative experiment concerning thresholds of sift features]
 % INPUTS 
 %			picture = ..
 %			range = thresholds
 % OUTPUTS 



picture_ = im2double(mat2gray(picture));
figure();

hold on;

counter = 0;

for i=range
    
    counter = counter + 1;
    
    subplot(1, numel(range), counter);
    
    [frame,De] = vl_sift(single(reshape(picture, 480, 512)),'PeakThresh', i) ;
    
    imshow(single(reshape(picture_, 480, 512)));hold on;
%     vl_plotsiftdescriptor(De,frame);
    scatter(frame(1,:), frame(2,:));
    hold off;
    title("Thresh ="+string(i));
    
end

end