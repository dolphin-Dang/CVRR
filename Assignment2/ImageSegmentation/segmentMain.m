% read images
imgNameList = {"gumballs.jpg","snake.jpg","twins.jpg","planets.jpg","coins.jpg"};
gumballs = imread(imgNameList{1});
snake = imread(imgNameList{2});
twins = imread(imgNameList{3});
planets = imread(imgNameList{4});
imgList = {gumballs,snake,twins,planets};
% coins = imread(imgList{5});

% load filterbank from .mat file
% val 'F' is the filterBank
load('filterBank.mat');
bank = F;
% displayFilterBank(bank);
subBanksIdx = [1,2,6,7,8,12,13,14,18,19,20,24,25,26,30,31,32,36];
subBanks = bank(:,:,subBanksIdx);

% configs here to choose (hyp-paras)
k = 10;
winSize = 12;
numColorRegions = 5;
numTextureRegions = 5;

% inits: get textons
imStack = {rgb2gray(gumballs), rgb2gray(snake), rgb2gray(twins), rgb2gray(planets)};
textons = createTextons(imStack, bank, k);
subTextons = createTextons(imStack, subBanks, k);

% plots
figure;
subplotIdx = 1;
ttlRows = length(imgList);
ttlCols = 4;
for i=1:length(imgList)
    img = imgList{i};
    [colorLabelIm,textureLabelIm] = compareSegmentations(img,bank,textons,winSize,numColorRegions,numTextureRegions);
    [~,subBankTextureLabelIm] = compareSegmentations(img,subBanks,subTextons,winSize,numColorRegions,numTextureRegions);

    % raw img
    subplot(ttlRows, ttlCols, subplotIdx);
    subplotIdx = subplotIdx + 1;
    imshow(imgList{i});
    title(imgNameList{i});
    % color img
    subplot(ttlRows, ttlCols, subplotIdx);
    subplotIdx = subplotIdx + 1;
    imshow(label2rgb(colorLabelIm));
    title("Color based k-means output");
    % texture img
    subplot(ttlRows, ttlCols, subplotIdx);
    subplotIdx = subplotIdx + 1;
    imshow(label2rgb(textureLabelIm));
    title("Texture based k-means output");
    % subset of banks texture img
    subplot(ttlRows, ttlCols, subplotIdx);
    subplotIdx = subplotIdx + 1;
    imshow(label2rgb(subBankTextureLabelIm));
    title("Subset Banks' Texture");
end

% change window size to illustrate something
% just change hyp-params above, no need to write any more codes
% pass

% use all and subsets of filter banks to illustrate something
% make a subBanks and do the test above!
% pass

