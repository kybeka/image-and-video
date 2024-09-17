close all;
clear;
clc;

img_happy = im2double(imread('happy.jpg'));
img_sad = im2double(imread('sad.jpg'));

sigma_max = 5;
sigma_incr = 0.5;
num_images = ceil(sigma_max / sigma_incr);
hybrid_images = cell(1, num_images);


for i = num_images:-1:1
    cutoff = sigma_incr * i;
    
    img_happy_filt = img_happy - imgaussfilt(img_happy, cutoff); %high pass    
    img_sad_filt = imgaussfilt(img_sad, cutoff); % low pass

    [rows, cols, ~] = size(img_happy_filt);
    img_sad_filt = imresize(img_sad_filt, [rows, cols]); %same size

    % hybrid image
    img_hybrid = img_happy_filt + img_sad_filt;
    hybrid_images{i} = img_hybrid;
end

figure;
montage(hybrid_images, 'Size', [1, num_images]);
sgtitle('From sad to happy');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

img_happy = im2double(imread('happy.jpg'));
img_sad = im2double(imread('sad.jpg'));

sigma_max = 5;
sigma_incr = 0.5;
num_images = ceil(sigma_max / sigma_incr);
hybrid_images = cell(1, num_images);


for i = num_images:-1:1
    cutoff = sigma_incr * i;
    
    img_sad_filt = img_sad -imgaussfilt(img_sad, cutoff);%high pass
    img_happy_filt = imgaussfilt(img_happy, cutoff); % low pass

    [rows, cols, ~] = size(img_happy_filt);
    img_sad_filt = imresize(img_sad_filt, [rows, cols]); %same size

    % hybrid image
    img_hybrid = img_happy_filt + img_sad_filt;
    hybrid_images{i} = img_hybrid;
end

figure;
montage(hybrid_images, 'Size', [1, num_images]);
sgtitle('From happy to sad');
