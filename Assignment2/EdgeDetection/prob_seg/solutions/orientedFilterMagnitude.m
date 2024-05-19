function [mag, theta] = orientedFilterMagnitude(im)
    % turn RGB img to gray img
    % im_gray = double(rgb2gray(im));
    % im_gray = rgb2gray(im);
    im_hsv = rgb2hsv(im);
    [h,w,d] = size(im);

    % inits
    orientations = [0, 45, -45, 90, -90, 30, -30, 60, -60];
    orientNum = length(orientations);
    sigma = 3; % try sigmas here
    ksize = 4*sigma+1;
    gaussianFilter = fspecial("gaussian", [ksize, ksize], sigma);
    [gaussianX, gaussianY] = gradient(gaussianFilter);
    
    mag = zeros(h,w);
    theta = zeros(h,w);
    
    for i = 1:orientNum
        % steerable gaussian
        theta_i = orientations(i);
        cosTheta = cos(theta_i);
        sinTheta = sin(theta_i);
        Gtheta = cosTheta*gaussianX + sinTheta*gaussianY;

        imFiltered = imfilter(im_hsv, Gtheta, "replicate", "conv");
        output = sqrt(sum(imFiltered.^2, 3));
        %disp(size(imFiltered));
        %disp(size(output));
        %output = abs(imFiltered);
        mag = max(mag, output);
        maxMask = (mag == output);
        %[gradx, grady] = gradient(imFiltered);
        %magTheta = sqrt(gradx.^2 + grady.^2);
        %mag = max(mag, magTheta);
        %maxMask = (mag == magTheta);
        theta(maxMask) = theta_i;
    end
end