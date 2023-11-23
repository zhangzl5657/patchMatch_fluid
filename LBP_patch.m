function [minValue,rotN ] = LBP_patch(patch)
%UNTITLED Summary of this function goes here
% 计算3*3大小的块的LBP值，及其获得最小值时的旋转角度
% value
%   Detailed explanation goes here
neighbors = 8; %默认取8邻域
[szh,szw] = size(patch);
% 获得块的中心坐标
cy = floor(szh/2)+1;
cx = floor(szw/2)+1;

%计算中心元素值
cvalue = patch(cy,cx);
% 获得初始LB编码
mask = zeros(szh,szw);
mask(:,:) = cvalue;
lbcode = patch>mask; 

%生成邻域列向量
neighborV = zeros(neighbors,1);
neighborV(1:3) = lbcode(1,:);
neighborV(4) = lbcode(2,3);
neighborV(5:7) = lbcode(3,3:-1:1);
neighborV(8) = lbcode(2,1);

% 权重模板（列向量）
weight = [1 2 4 8 16 32 64 128]';

minValue = sum(neighborV .* weight);
rotN = 0; %顺时针旋转次数
%旋转不变性
for i=1:7
temVec = circshift(neighborV,i);
temValue = sum(temVec .* weight);
if temValue < minValue
    minValue = temValue;
    rotN = i;
end
end
end

