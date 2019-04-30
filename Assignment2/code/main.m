close all
clear all
vl_setup()

% load images
disp("Loading images");
directory = "House";
start_at = 1;
how_many = 3;
imgs = load_data(directory, how_many, start_at);

% for now pic the first two pictures: TODO: something else?
pic1 = imgs(1, :, :);
pic2 = imgs(2, :, :);

% do eight point algorithm
methods = ["standard", "normalized", "ransac"];
result = eight_point(pic1, pic2, methods(2));


