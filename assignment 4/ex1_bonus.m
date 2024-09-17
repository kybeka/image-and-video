close all;
clear;
clc;

img = imread('queen.jpg');
img = im2double(img);


linear_img = srgb_to_linear(img);

temperature_shift = 20; % toggle
linear_img_wb = adjust_white_balance(linear_img, temperature_shift);

contrast_factor = 1.2; % toggle
brightness_offset = 0.1; % toggle
linear_img_wb_cb = adjust_contrast(linear_img_wb, contrast_factor);
linear_img_wb_cb = adjust_brightness(linear_img_wb_cb, brightness_offset);


lab_img = rgb2lab(linear_img_wb_cb);
lab_img_reshaped = reshape(lab_img, [], 3);
num_clusters = 7;
[idx_lab, centroids_lab] = kmeans(lab_img_reshaped, num_clusters, 'Distance', 'sqeuclidean', 'Replicates', 5);

layers_lab = zeros([size(img), num_clusters]);
for k = 1:num_clusters
    mask_lab = reshape(idx_lab == k, size(img, 1), size(img, 2));
    for c = 1:3 % create the layers
        layers_lab(:,:,c,k) = lab_img(:,:,c) .* mask_lab;
    end
end


% create a copy
modified_layers_lab = layers_lab;

lightness_boost = 20; % toggle
modified_layers_lab(:,:,1,1) = min(modified_layers_lab(:,:,1,1) + lightness_boost, 100);

hue_shift = 20; % toggle
modified_layers_lab(:,:,2,2) = modified_layers_lab(:,:,2,2) + hue_shift; 
modified_layers_lab(:,:,3,2) = modified_layers_lab(:,:,3,2) - hue_shift; 

saturation_scale = 1.5; % toggle
modified_layers_lab(:,:,2,3) = modified_layers_lab(:,:,2,3) * saturation_scale;
modified_layers_lab(:,:,3,3) = modified_layers_lab(:,:,3,3) * saturation_scale;

modified_layers_srgb = zeros(size(modified_layers_lab));
for k = 1:num_clusters
    modified_layers_srgb(:,:,:,k) = lab2rgb(modified_layers_lab(:,:,:,k));
end

result_img_lab = zeros(size(img));
for k = 1:num_clusters
    result_img_lab = result_img_lab + modified_layers_lab(:,:,:,k);
end

result_img_linear = lab2rgb(result_img_lab);
result_img_srgb = linear_to_srgb(result_img_linear);

%%%%%%%%%%%%%%%% For displaying:

figure;
imshow(result_img_srgb);
sgtitle('Resulting Modified Image');

figure;
subplot(1, 1, 1);
imshow(img);
sgtitle('Original Image');

figure;
for k = 1:num_clusters
    subplot(1, num_clusters, k);
    imshow(modified_layers_srgb(:,:,:,k));
    title(['Modified Layer ', num2str(k)]);
end
sgtitle('Modified Layers');


figure;
img_wb_cb_srgb = linear_to_srgb(linear_img_wb_cb);
imshow(img_wb_cb_srgb);
sgtitle('Image with Adjusted White Balance, Contrast, and Brightness');

%%%%%%%%%%%%%%% Helper functions:

function linear_img = srgb_to_linear(img)
    threshold = 0.04045;
    linear_img = img / 12.92;
    mask = img > threshold;
    linear_img(mask) = ((img(mask) + 0.055) / 1.055) .^ 2.4;
end

function srgb_img = linear_to_srgb(img)
    threshold = 0.0031308;
    srgb_img = img * 12.92;
    mask = img > threshold;
    srgb_img(mask) = 1.055 * (img(mask) .^ (1/2.4)) - 0.055;
end

function img_wb = adjust_white_balance(img, temperature_shift)
    img_lab = rgb2lab(img);
    img_lab(:,:,2) = img_lab(:,:,2) + temperature_shift; 
    img_lab(:,:,3) = img_lab(:,:,3) - temperature_shift; 
    img_wb = lab2rgb(img_lab);
end

function img_contrast = adjust_contrast(img, contrast_factor)
    img_contrast = img * contrast_factor;
    img_contrast = max(min(img_contrast, 1), 0); %from 0 to 1
end

function img_brightness = adjust_brightness(img, brightness_offset)
    img_brightness = img + brightness_offset;
    img_brightness = max(min(img_brightness, 1), 0); %from 0 to 1
end
