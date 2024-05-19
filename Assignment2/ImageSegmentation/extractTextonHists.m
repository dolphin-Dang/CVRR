function featIm = extractTextonHists(origIm,bank,textons,winSize)
    featMap = myconv(origIm, bank);
    [h,w,d] = size(featMap);
    [nTextons,~] = size(textons);
    featIm = zeros(h,w,nTextons);
    
    % map to textons from every pixels' neighbours
    labelIm = quantizeFeats(featMap, textons);
    pad = fix((winSize-1)/2);
    for i = 1:h
        for j = 1:w
            window = labelIm(max(i - pad, 1):min(i + pad, h), max(j - pad, 1):min(j + pad, w));
            unq = unique(window);
            freq = [unq, histc(window(:), unq)];
            featIm(i, j, freq(:, 1)) = freq(:, 2);
        end
    end
end

