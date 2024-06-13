clear;
clc;

numPoints = 10;

%mode = "manual";
mode = "auto";

% load images
% warp img2 to img1
img2 = imread('../uttower1.jpg');
img1 = imread('../uttower2.jpg');
%img1 = imread('../zzh1.jpg');
%img2 = imread('../zzh2.jpg');
%img1 = imread('../computer.jpg');
%img2 = img1;

if mode == "manual"
    figure(1);
    imshow(img1);
    [x1,y1] = ginput(numPoints);
    P1 = [x1, y1];
    
    figure(2);
    imshow(img2);
    [x2,y2] = ginput(numPoints);
    P2 = [x2, y2];
end

if mode == "auto"
    % use VLFeat here
    run('vlfeat-0.9.21/toolbox/vl_setup');
    
    gray1 = single(rgb2gray(img1));
    gray2 = single(rgb2gray(img2));
    [f1, d1] = vl_sift(gray1);
    [f2, d2] = vl_sift(gray2);
    [matches, scores] = vl_ubcmatch(d1, d2);
    
    numMatches = size(matches, 2);
    P1 = f1(1:2, matches(1, :))';
    P2 = f2(1:2, matches(2, :))';

    [H, inliers] = estimateGeometricTransform2D( ...
            P1, P2, ...
            'projective', ...
            'MaxNumTrials', 2000, ...
            'Confidence', 99.99 ...
        );
    
    % keep the inliers
    P1 = P1(inliers, :);
    P2 = P2(inliers, :);
    scores = scores(inliers);

    % choose the highest scores by sorting
    [~, sortedIdx] = sort(scores, 'descend');
    bestIdx = sortedIdx(1:min(numPoints, numMatches));
    P1 = P1(bestIdx, :);
    P2 = P2(bestIdx, :);
end

% save selected points for later usage
P = [P1, P2];
save("../tempValues/points.mat", "P");