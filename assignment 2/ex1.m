% Ex1. Linear Motion Blur Filter
clear;
clc;

img = double(imread("graz.png")) / 255;

theta = 45;   % Angle of motion
sigx = 7;      % Standard deviation along the x
sigy = 0.7;    % Standard deviation along the y

[blurred, h] = anisotropic(img, theta, sigx, sigy);
montage({img, blurred, h / max(h(:))}, 'Size', [1, 3]);
title('Anisotropic Gaussian motion blur');

function [blurred, h] = anisotropic(img, theta, sigx, sigy)
    angle = deg2rad(theta);
     
    % calculate size of filer
    sigma = [sigx, sigy];
    filter_size = 4*sigma+1;
    filter_size = abs([cos(angle) sin(angle)]) .* filter_size(1) + abs([sin(angle) cos(angle)]) .* filter_size(2);
    
    % create grid and rotate ellipsoid
    [X, Y] = meshgrid(-filter_size:filter_size, -filter_size:filter_size);
    X_rotated = -X * cos(angle) + Y * sin(angle);
    Y_rotated = X * sin(angle) + Y * cos(angle);
    
    % create anisotropic gf
    h = exp(-(X_rotated.^2 / (2 * sigx^2) + Y_rotated.^2 / (2 * sigy^2)));
    h = h / sum(h, 'all'); % normalize to add up to 1
    
    % apply with imfilter
    blurred = imfilter(img, h, 'conv', 'replicate');
end

