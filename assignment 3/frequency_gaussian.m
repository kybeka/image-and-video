function [ img2_filtered, img_2dft, gf_freq, img2_filtered_fft ] = frequency_gaussian(img, sigma_s)
    sigma_f = (1/(2*pi*sigma_s));

    % Convert to frequency domain (2D Fourier Transformation)
    img_2dft = fft2(img);
    % Shift lower frequencies to the center of fourier spectrum (shift the
    % DC component)
    img_2dft = fftshift(img_2dft);

    % Computing gaussian filter
    [X,Y]= meshgrid(-size(img,1)/2:size(img,1)/2-1,-size(img,2)/2:size(img,2)/2-1);
    D = sqrt(X.^2 + Y.^2);
    D = D/max(D(:));
    D = exp(-D.^2/2/sigma_f^2);
    gf_freq = D/max(D(:)); %normalize D again jic


    % Perform gaussian filtering in frequency domain (point-wise operation)
    img2_filtered_fft = img_2dft .* gf_freq;

    % inverse fourier transformation (and shift back DC component)
    % Bring image back to spatial domain
    img2_filtered = ifft2(ifftshift(img2_filtered_fft));
end