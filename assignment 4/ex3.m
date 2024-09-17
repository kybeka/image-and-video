close all;
clear;
clc;

img_sad = imread('sad.jpg');
img_happy = imread('happy.jpg');

levels = 4; %as per assignment

[gaussian_pyramid_sad, laplacian_pyramid_sad, reconstructed_sad] = pyramids(img_sad, levels);
[gaussian_pyramid_happy, laplacian_pyramid_happy, reconstructed_happy] = pyramids(img_happy, levels);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% reconstructing the laplacian
function reconstructed_img = reconstruct_laplacian(laplacian_pyramid)
    levels = length(laplacian_pyramid);
    reconstructed_img = laplacian_pyramid{levels};
    
    for i = levels-1:-1:1
        upsampled_img = imresize(reconstructed_img, size(laplacian_pyramid{i}(:,:,1)), 'nearest');
        reconstructed_img = upsampled_img + laplacian_pyramid{i};
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% computing both pyramids
function [gaussian_pyramid, laplacian_pyramid, reconstructed_img] = pyramids(img, levels)
    img = im2double(img);

    gaussian_pyramid = cell(levels, 1);
    gaussian_pyramid{1} = img; % first layer is original image
    for i = 2:levels
        img = imgaussfilt(gaussian_pyramid{i-1}, 1);
        img = imresize(img, 0.5, 'nearest');
        gaussian_pyramid{i} = img;
    end
    
    laplacian_pyramid = cell(levels, 1); %initialize
    for i = 1:levels-1
        prev_img = imresize(gaussian_pyramid{i+1}, size(gaussian_pyramid{i}(:,:,1)), 'nearest');
        laplacian_pyramid{i} = gaussian_pyramid{i} - prev_img;
    end
    laplacian_pyramid{levels} = gaussian_pyramid{levels}; % last one = gaussian

    % display gaussian
    figure;
    for i = 1:levels
        subplot(1, levels, i);
        imshow(gaussian_pyramid{i}, []);
        title(['Gaussian Level ', num2str(i)]);
    end

    % display laplacian (with brightness adjustment for visualization)
    figure;
    for i = 1:levels
        brightened_lap = imadjust(laplacian_pyramid{i}, stretchlim(laplacian_pyramid{i}), []);
        subplot(1, levels, i);
        imshow(brightened_lap, []);
        title(['Laplacian Level', num2str(i)]);
    end

    % display the reconstructed images
    figure;
    reconstructed_img = reconstruct_laplacian(laplacian_pyramid);
    imshow(reconstructed_img, []);
end


