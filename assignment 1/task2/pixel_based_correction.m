% Pixel-based correction
clc;
clear all;

% read
I = imread("white_balance_input.jpg");
I_double = im2double(I);

% gamma correction
I_double = I_double .^ (1 / 2.2);


% pixel based correction
figure(); 
imshow(I_double);
hold on; 
picked_pixel = int32(ginput(1));
plot(picked_pixel(1), picked_pixel(2), 'ro', 'MarkerSize', 10); % highlighter
hold off; 
pixel_color = I_double(picked_pixel(2), picked_pixel(1), 1:3); %select array [r, g, b]
channel_mean = mean(mean(I_double));
gain = pixel_color./channel_mean;

I_pix_corr = I_double.*gain;

imwrite(I_pix_corr, "./task2/I_pix_corr.jpg");