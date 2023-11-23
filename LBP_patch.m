function [minValue,rotN ] = LBP_patch(patch)
%UNTITLED Summary of this function goes here
% ����3*3��С�Ŀ��LBPֵ����������Сֵʱ����ת�Ƕ�
% value
%   Detailed explanation goes here
neighbors = 8; %Ĭ��ȡ8����
[szh,szw] = size(patch);
% ��ÿ����������
cy = floor(szh/2)+1;
cx = floor(szw/2)+1;

%��������Ԫ��ֵ
cvalue = patch(cy,cx);
% ��ó�ʼLB����
mask = zeros(szh,szw);
mask(:,:) = cvalue;
lbcode = patch>mask; 

%��������������
neighborV = zeros(neighbors,1);
neighborV(1:3) = lbcode(1,:);
neighborV(4) = lbcode(2,3);
neighborV(5:7) = lbcode(3,3:-1:1);
neighborV(8) = lbcode(2,1);

% Ȩ��ģ�壨��������
weight = [1 2 4 8 16 32 64 128]';

minValue = sum(neighborV .* weight);
rotN = 0; %˳ʱ����ת����
%��ת������
for i=1:7
temVec = circshift(neighborV,i);
temValue = sum(temVec .* weight);
if temValue < minValue
    minValue = temValue;
    rotN = i;
end
end
end

