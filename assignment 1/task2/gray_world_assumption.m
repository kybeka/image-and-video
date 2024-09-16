% Gray-world assumption
clc;
clear all;

% read
I = imread("white_balance_input.jpg");
I_double = im2double(I);

% gamma correction
I_double = I_double .^ (1 / 2.2);

channel_mean = mean(mean(I_double));
gain = channel_mean/mean(channel_mean);
I_gray_world = I_double./gain;

imwrite(I_gray_world, "./task2/I_gray_world.jpg");
