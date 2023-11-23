function [ rotM ] = rotMatrix( M,rotN )
%UNTITLED Summary of this function goes here
% 实现3*3矩阵中外圈元素任意循环移位rotN
% rotN为正数时为顺时针移位，为负数时为逆时针移位
%   Detailed explanation goes here

% 设定3*3矩阵外圈元素个数为8
n = 8;
vectorM = zeros(n,1);
%% 将矩阵M的外圈元素行成列向量，赋值给vectorM
vectorM(1:3) = M(1,:);
vectorM(4) = M(2,3);
vectorM(5:7) = M(3,3:-1:1);
vectorM(8) = M(2,1);
%% 旋转向量vectorM
vectorM = circshift(vectorM,rotN);

%% 将旋转后的向量vectroM赋值给M的外圈元素
M(1,:) = vectorM(1:3);
M(2,3) = vectorM(4);
M(3,:) = vectorM(7:-1:5);
M(2,1) = vectorM(8);

%% 返回结果
rotM = M;

end

