function [mag,theta] = gradientMagnitude(im,sigma)
    R = im(:,:,1);
    G = im(:,:,2);
    B = im(:,:,3);
    
    % do gaussian smooth
    ksize = 4*sigma+1;
    gaussianFilter = fspecial("gaussian", [ksize, ksize], sigma);
    R_smooth = imfilter(R, gaussianFilter, "replicate");
    G_smooth = imfilter(G, gaussianFilter, "replicate");
    B_smooth = imfilter(B, gaussianFilter, "replicate");
    
    % compute gradients
    [R_gradx, R_grady] = gradient(R_smooth);
    [G_gradx, G_grady] = gradient(G_smooth);
    [B_gradx, B_grady] = gradient(B_smooth);
    
    % compute magnitudes
    magR = sqrt(R_gradx.^2 + R_grady.^2);
    magG = sqrt(G_gradx.^2 + G_grady.^2);
    magB = sqrt(B_gradx.^2 + B_grady.^2);

    % compute theta by the max channel index
    [~, maxID] = max(cat(3,magR,magG,magB), [], 3);

    maxIDR = (maxID(:,:,1)==1);
    maxIDG = (maxID(:,:,1)==2);
    maxIDB = (maxID(:,:,1)==3);
    theta = zeros(size(im(:,:,1)), "like", im);
    theta(maxIDR) = atan2(R_grady(maxIDR), R_gradx(maxIDR));
    theta(maxIDG) = atan2(G_grady(maxIDG), G_gradx(maxIDG));
    theta(maxIDB) = atan2(G_grady(maxIDB), G_gradx(maxIDB));
    
    % compute magnitude by L2-norm
    mag = sqrt(magR.^2 + magG.^2 + magB.^2);
end

