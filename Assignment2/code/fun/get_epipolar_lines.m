function [] = get_epipolar_lines(F, img1, img2, p_1, p_2, n)
 % get_epipolar_lines		 [Visualizes epipolar lines]
 % INPUTS 
 %			F = fundamental matrix
 %			img_1 = image 1 of the image pair 
 %			img_2 = image 2 of the image pair
 %          p1 = matching points in image 1
 %          p2 = matching points in image 2
 %          n = number of points/epipolar lines sampled
 
%normalize image intensities
I1 = im2double(mat2gray(img1));
I2 = im2double(mat2gray(img2));


%Get random subset of size n of frames with matching features
permutations = randperm(size(p_2,1));
idxs = permutations(1:n);

%Get corresponding points
p1 = p_1(idxs, :);
p2 = p_2(idxs, :);


figure(1);

subplot(1, 2, 1);
imshow(I1)
hold on
scatter(p1(:,1), p1(:, 2), 50, 'green', 'filled')


subplot(1, 2, 2);
imshow(I2)
hold on

for i = 1:size(p1, 1)
    
    %get epipolar line corresponding to p1
    p = F*p1(i,:)';
    
    %get x coordinates to plot epipolar line
    x = linspace(0, size(I2, 2));
    % get corresponding y coordinates for epipolar line
    y = -(p(1)*x + p(3))/p(2);

    %plot epipolar line
    line = plot(x, y);
    line.LineWidth = 1.5;
    
    %plot point on image 2 matching to p1
    scatter(p2(i,1), p2(i, 2), 50, get(line, 'Color'), 'filled')
end

end







