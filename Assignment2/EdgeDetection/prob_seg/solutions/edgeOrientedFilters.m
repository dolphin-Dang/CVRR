function bmap = edgeOrientedFilters(im)
    % try some sigmas here
    [mag, ~] = orientedFilterMagnitude(im);
    
    % get canny edges
    canny_edges = edge(rgb2gray(im), "canny");
    edgeID = find(canny_edges);

    % use canny edge to retain the magnitude
    bmap = zeros(size(im(:,:,1)), "like", im);
    for idx = 1:length(edgeID)
        [i, j] = ind2sub(size(canny_edges), edgeID(idx));
        bmap(i, j) = mag(i, j);
    end
end

