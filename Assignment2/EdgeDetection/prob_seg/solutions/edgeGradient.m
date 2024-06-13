function bmap = edgeGradient(im)
    % try some sigmas here
    sigma = 1;
    [mag, ~] = gradientMagnitude(im, sigma);
    
    % get canny edges
    canny_edges = edge(rgb2gray(im), "canny");
    bmap = mag.*canny_edges;

end

