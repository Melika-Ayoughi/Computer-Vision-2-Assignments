close all
clear all
vl_setup()


% load images
disp("Loading images");
directory = "House";
start_at = 1;
how_many = 3;
imgs = load_data(directory, how_many, start_at);

% detect feature points
disp("Getting feature points");
feature_points = generate_feature_points(imgs);

% matching feature points
vl_ubcmatch