function labelIm = quantizeFeats(featIm,meanFeats)
    [h,w,d] = size(featIm);
    % [k,d] = size(meanFeats);

    % compute dist
    dists = dist2(reshape(featIm, [h*w,d]), meanFeats);
    % disp(size(dists));
    [~,minIDX] = min(dists, [], 2);
    
    % get minimum
    labelIm = reshape(minIDX, [h,w]);
end

