%%%%% Ex3. Image Stylization 
clear;
clc;

I = imread('delicate_arch.jpg');
I_ycbcr = rgb2ycbcr(double(I)./255);   %this is a transformation that you will learn about in later lectures, dont worry about it now
I_gray = double(rgb2gray(I))./255;     %Just use this gray-scale image for any further processing

sigma_space = 5;
sigma_range = 0.1;
I_smooth = imbilatfilt(I_gray, sigma_range, sigma_space);

I_edge = edge(I_smooth, 'Canny');

structuring_element = strel('disk', 1);
I_edge_dilated = imdilate(I_edge, structuring_element);
figure; montage({I_smooth, I_edge_dilated});

result = I_smooth;
result(I_edge_dilated) = 0;

%%%%%%%% Processing %%%%%%%%%%%

J_ycbcr = cat(3,result,I_ycbcr(:,:,2),I_ycbcr(:,:,3)); %replace 'result' with your processed gray-scale output
J_rgb = ycbcr2rgb(J_ycbcr);           %this is a transformation that you will learn about in later lectures, dont worry about it now
figure;
imshow(J_rgb);
