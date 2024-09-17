close all;
clear;
clc;

% Load image
img = imread('queen.jpg');
img = im2double(img);

linear_img = srgb_to_linear(img); % call function
lab_img = rgb2lab(img); % convert to cielab

% Reshape the image data for clustering
img_reshaped = reshape(img, [], 3);
linear_img_reshaped = reshape(linear_img, [], 3);
lab_img_reshaped = reshape(lab_img, [], 3);

% k-means clustering in both spaces
num_clusters = 7;
[idx_srgb, centroids_srgb] = kmeans(img_reshaped, num_clusters, 'Distance', 'sqeuclidean', 'Replicates', 5);
[idx_linear, centroids_linear] = kmeans(linear_img_reshaped, num_clusters, 'Distance', 'sqeuclidean', 'Replicates', 5);
[idx_lab, centroids_lab] = kmeans(lab_img_reshaped, num_clusters, 'Distance', 'sqeuclidean', 'Replicates', 5);


% holding the layers
layers_srgb = zeros([size(img), num_clusters]);
layers_linear = zeros([size(img), num_clusters]);
layers_lab = zeros([size(img), num_clusters]);

% assign pixels to their respective layers
for k = 1:num_clusters
    mask_srgb = reshape(idx_srgb == k, size(img, 1), size(img, 2));
    mask_linear = reshape(idx_linear == k, size(img, 1), size(img, 2));
    mask_lab = reshape(idx_lab == k, size(img, 1), size(img, 2));
    for c = 1:3 % create the layers
        layers_srgb(:,:,c,k) = img(:,:,c) .* mask_srgb;
        layers_linear(:,:,c,k) = img(:,:,c) .* mask_linear;
        layers_lab(:,:,c,k) = lab_img(:,:,c) .* mask_lab;
    end
end

% convert each layer to HSL
layers_hsl_srgb = zeros(size(layers_srgb));
layers_hsl_linear = zeros(size(layers_linear));
layers_srgb_lab = zeros(size(layers_lab));
for k = 1:num_clusters
    layers_hsl_srgb(:,:,:,k) = rgb2hsv(layers_srgb(:,:,:,k));
    layers_hsl_linear(:,:,:,k) = rgb2hsv(layers_linear(:,:,:,k));
    layers_srgb_lab(:,:,:,k) = lab2rgb(layers_lab(:,:,:,k));
end

%%%%%%%%%%%%%%%% For displaying:

% Set the size of the color square
color_square_size = 50;

% Create and display the sRGB color strips and layers
figure;
for k = 1:num_clusters
    % sRGB Color strip
    color_square = repmat(reshape(centroids_srgb(k, :), 1, 1, 3), color_square_size, color_square_size);
    subplot(2, num_clusters, k);
    imshow(color_square);
    title(['sRGB Color ', num2str(k)]);
    
    % sRGB Layer
    subplot(2, num_clusters, k + num_clusters);
    imshow(layers_srgb(:,:,:,k));
    title(['sRGB Layer ', num2str(k)]);
end
sgtitle('sRGB Palette and Layers');

%Linear
figure;
for k = 1:num_clusters
    color_square = repmat(reshape(centroids_linear(k, :), 1, 1, 3), color_square_size, color_square_size);
    subplot(2, num_clusters, k);
    imshow(color_square);
    title(['Linear RGB Color ', num2str(k)]);
    
    % Linear RGB Layer
    subplot(2, num_clusters, k + num_clusters);
    imshow(layers_linear(:,:,:,k));
    title(['Linear RGB Layer ', num2str(k)]);
end
sgtitle('Linear RGB Palette and Layers');

%Cielab
%convert lab to rgb for visualization
figure;
for k = 1:num_clusters
    color_square = repmat(reshape(lab2rgb(centroids_lab(k, :)), 1, 1, 3), color_square_size, color_square_size);
    subplot(2, num_clusters, k);
    imshow(color_square);
    title(['CIELab Color ', num2str(k)]);
    
    subplot(2, num_clusters, k + num_clusters);
    imshow(layers_srgb_lab(:,:,:,k));
    title(['CIELab Layer ', num2str(k)]);
end
sgtitle('CIELab Palette and Layers');

%%%%%%%%%%%%%%%% Modify specific layers for artistic effects:

modified_layers_lab = layers_lab;

lightness_boost = 20;
modified_layers_lab(:,:,1,1) = min(modified_layers_lab(:,:,1,1) + lightness_boost, 100);

hue_shift = 20;
modified_layers_lab(:,:,2,2) = modified_layers_lab(:,:,2,2) + hue_shift; % a* channel
modified_layers_lab(:,:,3,2) = modified_layers_lab(:,:,3,2) - hue_shift; % b* channel

saturation_scale = 1.5;
modified_layers_lab(:,:,2,3) = modified_layers_lab(:,:,2,3) * saturation_scale;
modified_layers_lab(:,:,3,3) = modified_layers_lab(:,:,3,3) * saturation_scale;

modified_layers_srgb = zeros(size(modified_layers_lab));
for k = 1:num_clusters
    modified_layers_srgb(:,:,:,k) = lab2rgb(modified_layers_lab(:,:,:,k));
end

%%%%%%%%%%%%%%%% For displaying the modified layers:


figure;
for k = 1:num_clusters
    color_square = repmat(reshape(lab2rgb(centroids_lab(k, :)), 1, 1, 3), color_square_size, color_square_size);
    subplot(2, num_clusters, k);
    imshow(color_square);
    title(['Modified CIELab Color ', num2str(k)]);
    
    % Modified CIELab Layer converted to sRGB for display
    subplot(2, num_clusters, k + num_clusters);
    imshow(modified_layers_srgb(:,:,:,k));
    title(['Modified CIELab Layer ', num2str(k)]);
end
sgtitle('Modified CIELab Palette and Layers');

figure;
subplot(2, num_clusters + 1, 1);
imshow(img);
title('Original Image');
for k = 1:num_clusters
    subplot(2, num_clusters + 1, k + 1);
    imshow(modified_layers_srgb(:,:,:,k));
    title(['Modified Layer ', num2str(k)]);
end
sgtitle('Original and Modified Layers');

% Combine the modified layers to create the resulting modified image
result_img_lab = zeros(size(img));
for k = 1:num_clusters
    result_img_lab = result_img_lab + modified_layers_lab(:,:,:,k);
end
result_img_srgb = lab2rgb(result_img_lab);
figure;
imshow(result_img_srgb);
sgtitle('Resulting Modified Image');

%%%%%%%%%%%%%%%% Additional Helper Function:

function linear_rgb = srgb_to_linear(srgb)
    % Apply inverse sRGB gamma correction
    threshold = 0.04045;
    linear_rgb = srgb / 12.92;
    % Create a mask for values above the threshold
    mask = srgb > threshold;
    % Apply the non-linear transformation for values above the threshold
    linear_rgb(mask) = ((srgb(mask) + 0.055) / 1.055) .^ 2.2;
end
