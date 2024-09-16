% Task 1
clc;
clear all;

% Specify the image file
image_file = 'ferrari.JPG';

gamma = 2.2;
alpha = 2;
beta = 0.6;

% Here, we are performing both the linear and exponential functions
% in AFTER gamma correcting
linearized_image = gamma_correction(image_file, gamma);
brightened_image = brightness_increase(strcat('linearized_', image_file), alpha);
contrasted_image = contrast_increase(strcat('linearized_', image_file), beta);

% Also read original image for display
I = imread(image_file);

% Display
figure;

% Original Image
subplot(2, 2, 1);
imshow(I);
title('Original Image');

% Linearized Image
subplot(2, 2, 2);
imshow(imresize(linearized_image, [size(I, 1), size(I, 2)]));
title('Linearized Image');

% Brightened Image
subplot(2, 2, 3);
imshow(imresize(brightened_image, [size(I, 1), size(I, 2)]));
title('Brightened Image');

% Contrasted Image
subplot(2, 2, 4);
imshow(imresize(contrasted_image, [size(I, 1), size(I, 2)]));
title('Contrasted Image');
