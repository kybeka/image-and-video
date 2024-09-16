% Task 5

clc;
clear all;

I = imread('cat.jpg');  
background = zeros(size(I));  % black background

composite_image = chroma_key(I, background);


imshow(composite_image);


function img = chroma_key(img, background)
    figure, imshow(img);
    [x, y] = ginput(1);
    key = img(round(y), round(x), :);
    mask = sum(abs(double(img) - double(key)) < 13, 3) == 3;
    mask = cat(3, mask, mask, mask);
    img(mask) = background(mask);
    
    imshow(img);
end
