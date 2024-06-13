clear;
clc;

img2 = imread("../uttower1.jpg");
img1 = imread("../uttower2.jpg");
%img1 = imread('../zzh1.jpg');
%img2 = imread('../zzh2.jpg');
%img1 = imread('../computer.jpg');
%img2 = img1;

load("../tempValues/H.mat");
[warped_img, minX, minY] = warpImg(H, img1);

% show warp results
figure('Position', [100,100,1200,600]);
subplot(1, 3, 1);
imshow(img1);
title('Original Image');

subplot(1, 3, 2);
imshow(warped_img);
hold on;
title('Warped Image');

% do mosaic
load("../tempValues/ref.mat");
%disp(size(ref));
ref = round(ref);
%plot(ref(3,1)-minX, ref(3,2)-minY, 'ro', 'MarkerSize', 8);
mosaic_img = createMosaic(warped_img, img2, ref, minX, minY);
subplot(1, 3, 3);
imshow(mosaic_img);
title('Mosaic Image');

function [output, minX, minY] = warpImg(H, img)
    [h, w, c] = size(img);

    [X, Y] = meshgrid(1:w, 1:h);
    points = [X(:), Y(:), ones(numel(X), 1)]';
    transformed_points = H * points;
    transformed_points = transformed_points ./ transformed_points(3, :);
    x_trans = transformed_points(1, :);
    y_trans = transformed_points(2, :);
    % make sure all coords are above zero
    minX = floor(min(x_trans));
    minY = floor(min(y_trans));
    x_trans = x_trans - minX;
    y_trans = y_trans - minY;
    maxX = ceil(max(x_trans));
    maxY = ceil(max(y_trans));
    disp(maxX);
    disp(maxY);
    output = zeros(maxY, maxX, c, "like", img);
    disp(size(output));
    disp(size(img));

    % use the re-scaled meshgrid as output format
    [X, Y] = meshgrid(1:maxX, 1:maxY);
    points = [X(:), Y(:), ones(numel(X), 1)]';
    % this cannot be simply inverted
    % re-rescaling needed
    points(1, :) = points(1, :) + minX;
    points(2, :) = points(2, :) + minY;
    original_points = H \ points;
    original_points = original_points ./ original_points(3, :);
    
    x_ori = original_points(1, :)';
    y_ori = original_points(2, :)';
    mask = (x_ori >= 1) & (x_ori <= w) & (y_ori >= 1) & (y_ori <= h);

    % go over all channels
    for ch = 1:c
        channel = double(img(:,:,ch));
        interp_channel = interp2(channel, x_ori(mask), y_ori(mask), "linear", 0); 
        temp = zeros(maxX * maxY, 1, "like", img);
        temp(mask) = interp_channel;
        output(:,:,ch) = reshape(temp, maxY, maxX);
    end
end

function mosaic_img = createMosaic(warped_img, img, ref, minX, minY)
    [h2, w2, c] = size(img);
    [maxY, maxX, ~] = size(warped_img);
    % ref(3,1) - minX = ref(2,1)
    ref = round(ref);
   
    h = maxY + h2 - min(h2-ref(2,2), maxY-(ref(3,2)-minY)) - min(ref(2,2), ref(3,2)-minY);
    w = maxX + w2 - min(w2-ref(2,1), maxX-(ref(3,1)-minX)) - min(ref(2,1), ref(3,1)-minX);
    
    % reference point coord
    ref_x = w - max(w2-ref(2,1), maxX-(ref(3,1)-minX));
    ref_y = h - max(h2-ref(2,2), maxY-(ref(3,2)-minY));
    %disp(h2-ref(2,2));
    %disp(maxY-(ref(3,2)-minY));
    %disp(ref_x);
    %disp(ref_y);
    % create output and put img2 first
    mosaic_img = zeros(h, w, c, 'like', img);
    %disp(size(mosaic_img));
    start_x = ref_x - ref(2,1);
    start_y = ref_y - ref(2,2);

    mosaic_img(start_y+1:start_y+h2, start_x+1:start_x+w2, :) = img;

    % try to put warped img1 then
    start_x = ref_x - (ref(3,1)-minX);
    start_y = ref_y - (ref(3,2)-minY);
    black_mask = all(warped_img == 0, 3);
    mosaic_img = double(mosaic_img);
    warped_img = double(warped_img);
    disp(start_x);
    disp(start_y);
    mosaic_img(start_y+1:start_y+maxY, start_x+1:start_x+maxX, :) = mosaic_img(start_y+1:start_y+maxY, start_x+1:start_x+maxX, :) .* black_mask + warped_img .* ~black_mask;
    mosaic_img = uint8(mosaic_img);
end