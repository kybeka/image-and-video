% Ex2. Iterative filtering
clear;
clc;

image_file = 'delicate_arch.jpg';
I = imread(image_file);
I = im2double(I);

num_iterations = 3;
sigma_space = 3;
sigma_range = 0.1;

filtered_image_small_kernel = I;
for i = 1:num_iterations
    filtered_image_small_kernel = imbilatfilt(filtered_image_small_kernel, sigma_range, sigma_space);
end

big_sigma_space = sigma_space * num_iterations;
big_sigma_range = sigma_range * num_iterations;
filtered_image_big_kernel = imbilatfilt(I, big_sigma_range, big_sigma_space);

montage({I, filtered_image_small_kernel, filtered_image_big_kernel}, 'Size', [1, 3]);