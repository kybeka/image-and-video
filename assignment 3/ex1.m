close all;
clear;
clc;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% given image size
image_size = 1024;

% intensity 0.8 (for the gray ones)
img = 0.8 * ones(image_size, image_size);

% black square
center_start = image_size / 4;  
center_end = 3 * image_size / 4;
img(center_start:center_end, center_start:center_end) = 0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% GF in spatial domain
sigma_s = 5;
[ img_spacial, kernel_s, gf_spatial ] = spatial_gaussian(img, sigma_s);

% GF in frequency domain
[ img2_filtered, img_2dft, gf_freq, img2_filtered_fft ] = frequency_gaussian(img, sigma_s);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% Spatial
subplot(1,3,1);
imshow(img);
title('Original image');
subplot(1,3,2);
imshow(gf_spatial, []);
title('Gaussian kernel in spatial domain');
subplot(1,3,3);
imshow(img_spacial);
title('Filtered image in spatial domain');


%% Frequency
% display with log and abs to display frequency better
figure;
subplot(1,4,1);
imshow(log(abs(img_2dft)));
title('FFT of padded and shifted image');
subplot(1,4,2);
imshow(gf_freq);
title('Gaussian kernel for frequency domain');
subplot(1,4,3);
imshow(log(abs(img2_filtered_fft)));
title('FFT of Filtered image in frequency domain');
subplot(1,4,4);  
imshow(img2_filtered);
title('Filtered image in frequency domain');


%% Result
figure;
montage({img, img_spacial, img2_filtered}, 'Size', [1, 3]);
title('Original Image vs. Spatial vs. Frequency Domain Filtering');




