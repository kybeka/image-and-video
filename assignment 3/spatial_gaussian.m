function [img_spacial, kernel_s, gf_spatial] = spatial_gaussian(img, sigma_s)
    kernel_s = 4*sigma_s+1;
    gf_spatial = fspecial('gaussian', kernel_s, sigma_s);
    img_spacial = conv2(img,gf_spatial,'same');
end