% Task 3

clc;
clear all;

I = imread('ferrari.JPG');
I_double = im2double(I);

% Separate the colors into channels
R = I_double(:, :, 1);
G = I_double(:, :, 2);
B = I_double(:, :, 3);

[counts_r, bins_r] = histcounts(R(:), 255);
[counts_g, bins_g] = histcounts(G(:), 255);
[counts_b, bins_b] = histcounts(B(:), 255);

% Plot
figure;
bar(bins_r(1:end-1), counts_r, 'r', 'FaceAlpha', 0.3);
hold on;
bar(bins_g(1:end-1), counts_g, 'g', 'FaceAlpha', 0.3);
bar(bins_b(1:end-1), counts_b, 'b', 'FaceAlpha', 0.3);
hold off;
title('Histogram');
legend('r', 'g', 'b');

