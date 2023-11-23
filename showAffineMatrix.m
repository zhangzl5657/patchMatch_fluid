function [ noAffPatchNum ] = showAffineMatrix( affineMatrix,I)
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here

[H,W,L] = size(affineMatrix);
noAffPatchNum = 0;
allMat = [];
for row = 1:H
    rowMat = [];
    for col = 1:W
        flag = affineMatrix(row,col,L);
        if flag >0
            currMat = affineMatrix(row,col,1:L-1);
            currMat = reshape(currMat,3,3);
        else
            currMat=zeros(3,3);
            noAffPatchNum = noAffPatchNum+1;
        end
        f = norm(currMat,'fro');
        tepMat = zeros(3,3)+f;
        rowMat = cat(2,rowMat,tepMat); %将图像每行的块仿射变换矩阵构造成一个行矩阵
    end
    allMat = cat(1,allMat,rowMat);
end
% colormap('gray');
figure
imshow(I);
hold on
% clims=[-5,5];
matI = imagesc(allMat);
matI.AlphaData = 0.5;
colorbar;
hold off;
end

