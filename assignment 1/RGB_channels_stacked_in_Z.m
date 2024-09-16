% Takes an RGB image and stacks the separate color channels at different Z levels.
imtool close all;  % Close all imtool figures if you have the Image Processing Toolbox.

clc;    % Clear the command window.
close all;  % Close all figures (except those of imtool.)
clear;  % Erase all existing variables. Or clearvars if you want.
workspace;  % Make sure the workspace panel is showing.
format long g;
format compact;
fontSize = 13;

filename = 'elmo.png';
rgbImage = imread(filename);
% Extract the individual red, green, and blue color channels.
redChannel = im2double(rgbImage(:, :, 1));
greenChannel = im2double(rgbImage(:, :, 2));
blueChannel = im2double(rgbImage(:, :, 3));

H(1) = slice(repmat(redChannel,[1 1 2]),[],[], 1); %slice() requires at least 2x2x2
set(H(1),'EdgeColor','none') %required so image isn't just an edge
hold on
H(2) = slice(repmat(greenChannel,[1 1 2]),[],[], 2); %slice() requires at least 2x2x2
set(H(2),'EdgeColor','none') %required so image isn't just an edge
H(3) = slice(repmat(blueChannel,[1 1 3]),[],[], 3); %slice() requires at least 2x2x2
set(H(3),'EdgeColor','none') %required so image isn't just an edge
hold off
colormap(gray(256))
axis ij
caption = sprintf('R, G, and B Color Channels of %s', filename);
title(caption, 'FontSize', fontSize);
% Put up legend that says what slice is what color channel.
legend('B', 'G', 'R')
