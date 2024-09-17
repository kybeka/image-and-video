close all;
clear;
clc;

img = imread('queen.jpg');

figure;
subplot(1, 4, 1);
imshow(img); 
title('Original')

img = im2double(img);


% Quantization
num_colors = 32;

% 1. Find LUT for HSV image
img_hsv = rgb2hsv(img);

shape_hsv = reshape(img_hsv, [], 3);
[ cluster_idx_hsv, cluster_color_hsv ] = kmeans(shape_hsv, num_colors);

img_clustered_hsv = reshape(cluster_color_hsv(cluster_idx_hsv, :), size(img_hsv, 1), size(img_hsv, 2), 3);

subplot(1, 4, 2);
imshow(hsv2rgb(img_clustered_hsv)); title('HSV')


% 2. Bonus: find LUT for CIELab image (+ luminance)

img_lab = rgb2lab(img);
shape_lab = reshape(img_lab, [], 3);
[ cluster_idx_lab, cluster_color_lab ] = kmeans(shape_lab, num_colors);

img_clustered_lab = reshape(cluster_color_lab(cluster_idx_lab, :), size(img_lab, 1), size(img_lab, 2), 3);

subplot(1, 4, 3);
imshow(lab2rgb(img_clustered_lab)); title('CIELab')


% And in grayscale:
cluster_color_rgb = lab2rgb(cluster_color_lab);
luminance = @(rgb) 0.2989 * rgb(:,1) + 0.5870 * rgb(:,2) + 0.1140 * rgb(:,3); % w/ formula
cluster_color_gray = luminance(cluster_color_rgb);
img_clustered_gray = reshape(cluster_color_gray(cluster_idx_lab, :), size(img, 1), size(img, 2), 1);

subplot(1, 4, 4);
imshow(img_clustered_gray); 
title('CIELab w/ luminance acccounted for');
