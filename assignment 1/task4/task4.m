% Task 4
clc;
clear all;

I = imread('ferrari.JPG');
hsv = rgb2hsv(I); % according to the assignment

% Original image
value_channel = hsv(:,:,3);
[height, width] = size(value_channel);

%%%%%%%%%%%%%%

% Global and Local equalization
histogram_value = imhist(value_channel);
cdf = cumsum(histogram_value);
cdf_normalized = cdf / (height * width);

% Mapping each pixel intensity to new normalized intensity
value_channel_equalized = interp1((0:255)/255, cdf_normalized, value_channel);
value_channel_equalized = value_channel_equalized / max(value_channel_equalized(:)); % rescaling

% Local equalization
window_size = 5;
value_channel_local_equalized = adapthisteq(value_channel, 'NumTiles', [floor(height/window_size), floor(width/window_size)]);
%histeq

%%%%%%%%%

figure;
subplot(3, 2, 1);
imshow(I);
title('Original Image');
subplot(3, 2, 2);
histogram(value_channel, 'Normalization', 'probability');
title('Original Image Histogram');

subplot(3, 2, 3);
imshow(hsv2rgb(cat(3, hsv(:,:,1:2), value_channel_equalized)));
title('Global Histogram Equalization');
subplot(3, 2, 4);
histogram(value_channel_equalized, 'Normalization', 'probability');
title('Global Histogram Equalization Histogram');

subplot(3, 2, 5);
imshow(hsv2rgb(cat(3, hsv(:,:,1:2), value_channel_local_equalized)));
title('Local Histogram Equalization');
subplot(3, 2, 6);
histogram(value_channel_local_equalized, 'Normalization', 'probability');
title('Local Histogram Equalization Histogram');
