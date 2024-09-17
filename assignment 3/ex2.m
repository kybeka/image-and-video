close all;

I = imread("san_domenico.png");
img = im2double(I);
img_fft = fft2(img);
[height, width, ~] = size(img); % get the height and width
i_select = abs(fftshift(img_fft)/(height/2));
[x, y, ~] = impixel(i_select); % get the pixels
mask = ones(height, width); % create the mask
radius = 10; % set a radius (can be changed and fine-tuned)
[h, w] = meshgrid(1:height); % create a grid of the same dimensions
for i = 1:size(x)
    mask((h-x(i)).^2+(w-y(i)).^2<radius^2) = 0; %ensure circles
end
res = img_fft .* fftshift(mask); % point-wise mask application
result = abs(ifft2(res));

figure; montage({I, abs(fftshift(img_fft)/(height/2))}, 'Size', [1, 2]);
figure; montage({abs(fftshift(img_fft)/500), mask, result}, 'Size', [1, 3]);
% figure; imshow(abs(fftshift(fft2(result))/(height/2)));
% abs(fftshift(fft2(result))/(height/2)) -> to show the mask applied on the
% fft
figure; montage({I, result}, 'Size', [1, 2]);