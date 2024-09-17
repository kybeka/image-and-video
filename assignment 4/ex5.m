deep_fry('dog.png');

function deep_fry(img)
    original = imread(img);
    imshow(original);

    disp('Please click on the positions of two eyes. If no eyes are present in the image, click wherever you please (e.g. corners).');
    [x, y] = ginput(2); % using the picker from the first assignment 
    p1 = [x(1), y(1)];
    p2 = [x(2), y(2)];

    % severely over-sharpen the image with kernel
    sharpened_img = imfilter(original, [-1 -1 -1; -1 9 -1; -1 -1 -1]);

    % saturation up
    saturation_factor = 3.0;
    hsv_img = rgb2hsv(sharpened_img);
    hsv_img(:, :, 2) = hsv_img(:, :, 2) * saturation_factor;
    hsv_img(hsv_img > 1) = 1;
    sat_img = hsv2rgb(hsv_img);

    % increase the red channel specifically slightly
    sat_img(:, :, 1) = sat_img(:, :, 1) * 1.2;
    sat_img(sat_img > 1) = 1;

    % reduce image quality + keep aspect ratio for eyes
    scale_factor = 1.5;
    reduced_qual_img = imresize(sat_img, 1 / scale_factor);
    p1 = p1 / scale_factor;
    p2 = p2 / scale_factor;

    % sharpen the image again for good measure
    final_img = imfilter(reduced_qual_img, [-1 -1 -1; -1 9 -1; -1 -1 -1]);

    % add flares where the ginput() was decided
    flare_radius = 50 / scale_factor; % move these based by the scale_factor previously
    flare_scale = 1.5;
    [X, Y] = meshgrid(1:size(final_img, 2), 1:size(final_img, 1));
    flare1 = flare_scale * exp(-((X - p1(1)).^2 + (Y - p1(2)).^2) / flare_radius^2); 
    flare2 = flare_scale * exp(-((X - p2(1)).^2 + (Y - p2(2)).^2) / flare_radius^2);
    flare = max(flare1, flare2);

    % blend back with the final image
    final_img(:,:,3) = final_img(:,:,3) + flare; % Add flares to blue channel
    imshow(final_img);
end
