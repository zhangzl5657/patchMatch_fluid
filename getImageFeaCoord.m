function [imageFeaCoord_X,imageFeaCoord_Y ] = getImageFeaCoord(szT,templateFeaCoord,colI,rowI,pz,tempImageFeaCoord_X,tempImageFeaCoord_Y)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

%% 计算模板包含多少个小patch
rowN=szT(1)/pz; %y方向包含多少个小patch
colN=szT(2)/pz; %x方向包含多少个小patch
N=rowN*colN;

%% 将当前模板中特征块的对应坐标存放到全局特征对应矩阵中
for i=1:N
    row = mod(i,rowN);   %特征块在邻域区域中y的坐标
    col = floor(i/rowN); %特征块在邻域区域中x的坐标
    if row == 0
        row = rowN;
        col = col-1;
    end
    fy = floor(rowI/pz)+row;
    fx = floor(colI/pz)+col+1;
    tempImageFeaCoord_Y(fy,fx) = templateFeaCoord(i,1);
    tempImageFeaCoord_X(fy,fx) = templateFeaCoord(i,2);
end
%% 返回整个图像的块特征对应坐标矩阵imageFeaCoord
imageFeaCoord_X = tempImageFeaCoord_X;
imageFeaCoord_Y = tempImageFeaCoord_Y;
end

