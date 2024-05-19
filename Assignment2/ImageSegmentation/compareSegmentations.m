function [colorLabelIm,textureLabelIm] = compareSegmentations(origIm,bank,textons,winSize,numColorRegions,numTextureRegions)
    [h,w,d] = size(origIm);

    % compute color Im
    colorFeats = kmeans(im2double(reshape(origIm, h*w, d)), numColorRegions);
    colorLabelIm = reshape(colorFeats, [h,w]);

    % compute texture Im
    textonHist = extractTextonHists(rgb2gray(origIm), bank, textons, winSize);
    textonFeats = kmeans(im2double(reshape(textonHist, h*w, size(textonHist, 3))), numTextureRegions);
    textureLabelIm = reshape(textonFeats, [h,w]);
end

