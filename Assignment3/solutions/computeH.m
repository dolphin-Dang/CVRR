clear;
clc;

load("../tempValues/points.mat");
P1 = P(:,1:2);
P2 = P(:,3:4);

% calculate matrix H
H = calcH(P1,P2);
save("../tempValues/H.mat", "H");

% verify matrix H
img2 = imread("../uttower1.jpg");
img1 = imread("../uttower2.jpg");
%img1 = imread('../zzh1.jpg');
%img2 = imread('../zzh2.jpg');
%img1 = imread('../computer.jpg');
%img2 = img1;

n = size(P1, 1);
P1_temp = H * [P1, ones(n, 1)]';
P1_mapped = P1_temp(1:2, :) ./ P1_temp(3, :);
P1_mapped = P1_mapped';
%disp(P1_mapped);

figure;
subplot(1, 2, 1);
imshow(img1);
hold on;
plot(P1(:, 1), P1(:, 2), 'ro', 'MarkerSize', 8);
%plot(P1_mapped(:, 1), P1_mapped(:, 2), 'bx', 'MarkerSize', 8);
title('Image 1 with Original Points(Red Os)');
hold off;

subplot(1, 2, 2);
imshow(img2);
hold on;
plot(P2(:, 1), P2(:, 2), 'ro', 'MarkerSize', 8);
plot(P1_mapped(:, 1), P1_mapped(:, 2), 'bx', 'MarkerSize', 8); 
title('Image 2 with Mapped Points(Blue Xs)');
hold off;

% save for later usage
ref = [P1(1, :); P2(1, :); P1_mapped(1, :)];
save("../tempValues/ref.mat", "ref");

% function to calculate matrix H from P1 & P2
function H = calcH(P1, P2)
    n = size(P1, 1);
    A = zeros(2*n, 8); % H(3,3)=1 
    b = zeros(2*n, 1);

    for i = 1:n
        x1 = P1(i, 1);
        y1 = P1(i, 2);
        x2 = P2(i, 1);
        y2 = P2(i, 2);

        A(2*i-1, :) = [x1, y1, 1, 0, 0, 0, -x2*x1, -x2*y1];
        A(2*i, :) = [0, 0, 0, x1, y1, 1, -y2*x1, -y2*y1];
        b(2*i-1) = x2;
        b(2*i) = y2;
    end

    h = A \ b;
    h(9) = 1;
    %disp(h);
    H = reshape(h, [3, 3])';
end