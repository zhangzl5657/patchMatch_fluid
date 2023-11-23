function [ Ix,Iy ] = IGradForHOG(img)
%UNTITLED2 Summary of this function goes here
% 求图像梯度 for hog
%   Detailed explanation goes here
if size(img,3) >1 %灰度处理
    img = rgb2gray(img);
end
img = im2double(img);
img=sqrt(img);      %伽马校正

%下面是求边缘
fy=[-1 0 1];        %定义竖直模板
fx=fy';             %定义水平模板
Iy=imfilter(img,fy,'replicate');    %竖直边缘
Ix=imfilter(img,fx,'replicate');    %水平边缘
end

