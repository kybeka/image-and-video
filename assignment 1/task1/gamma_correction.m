% This function will read an image file as a string,and undo the gamma
% correction that the original image had (linearize it). 
% An assumption can be made that gamma = (1/2.2) (from assignment).

function linearized_image = gamma_correction(image_file, gamma)

% Read
I = imread(image_file);
I_double = im2double(I);

% If hard-coded gamma: 
% gamma_value = 1/2.2;
gamma_value = gamma;

I_linearized = I_double .^ (1/gamma_value);

% Also, to save the linearized image:
output_file = strcat('linearized_', image_file);
imwrite(I_linearized, output_file);

% Return 
linearized_image = I_linearized;
end
