function [] = get_epipolar_lines(F, img1, img2, p_1, p_2, n, method, figure_number)  % DOCSTRING_GENERATED
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


figure(figure_number);

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
      
    % plot epipolar line
    length = size(I2, 1)*2;
    a = p(1);
    b = p(2);
    c = p(3);
    u = p_2(1);
    v = p_2(2);
    
    if(abs(a)<abs(b))
        d = length/sqrt((a/b)^2+1);
        drawpoint = [u-d, u+d ; (-c - a*(u-d))/b , (-c - a*(u+d))/b ];
    else
        d = length/sqrt((b/a)^2+1);
        drawpoint = [(-c - b*(v-d))/a , (-c - b*(v+d))/a ; v-d , v+d ];
    end
    
    line = plot(drawpoint(1,:), drawpoint(2,:));
    line.LineWidth = 1.5;

    
    %plot point on image 2 matching to p1
    scatter(p2(i,1), p2(i, 2), 50, get(line, 'Color'), 'filled')
    
    title(string(method));
end

end







