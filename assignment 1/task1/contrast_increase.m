% This function will reads an image, and then increases
% the contrast exponentially by a factor of beta (as seen in slides).

function contrasted_image = contrast_increase(image_file, beta)

% Read
I = imread(image_file);
I_double = im2double(I);

I_contrasted = I_double .^ beta;

% Also, to save the brightened image:
output_file = strcat('contrasted_', image_file);
imwrite(I_contrasted, output_file);

% Return
contrasted_image = I_contrasted;
end
