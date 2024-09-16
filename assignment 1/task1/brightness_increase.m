% This function will read an image, and then increases
% the brightness linearly by a factor of alpha (as seen in slides).


function brightened_image = brightness_increase(image_file, alpha)

% Read
I = imread(image_file);
I_double = im2double(I);


I_brightened = I_double.*alpha;

% Also, to save the brightened image:
output_file = strcat('brightened_', image_file);
imwrite(I_brightened, output_file);

% Return
brightened_image = I_brightened;
end
