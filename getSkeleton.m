function [ skeletonImg ] = getSkeleton( image,sigma )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

[height,width,t] = size(image);
if t>1
    grayImage = rgb2gray(image);
else
    grayImage = image;
end
skeletonImg = zeros(height,width);

%% 高斯滤波
h = fspecial('gaussian', [5 5], sigma);
grayImage = imfilter(grayImage,h,'same');
%% 计算图像的梯度
[Gx,Gy] = gradient(double(grayImage));
Gx = abs(Gx);
Gy = abs(Gy);
%% 设置影响骨架提取质量的两个参数
w = 10;%用于求最大梯度的区域长度
threshold = 5; %用于剔除微小变化区域内的最大梯度值

%% 求行方向（x）上的边
for row = 1:height
    temXval = 0;
    for col = 1:1:width
        if (col+w-1)<=width
            [maxVal,maxN] = max(Gx(row,col:col+w-1));
            [minVal,minN] = min(Gx(row,col:col+w-1));
            if (maxVal-minVal) >= threshold  
                if maxVal>temXval & col>1   %测试当前最大梯度值是否大于上一个最大梯度值，若是，则将上一个最大的梯度值对应的像素点重新设置为0
                    skeletonImg(row,col+maxN-2) = 0;
                    skeletonImg(row,col+maxN-1) = 100;
                    temXval = maxVal;
                end
            end
        end
   
    end
end

%% 求列方向（y）的边
for col = 1:width
    temYval = 0;
    for row = 1:1:height
        if (row+w-1)<=height
            [maxVal,maxN] = max(Gy(row:row+w-1,col));
            [minVal,minN] = min(Gy(row:row+w-1,col));
            if (maxVal-minVal) >= threshold            
                if maxVal>temYval
                    skeletonImg(max(1,min(row+maxN-2,height)),col) = 0;
                    skeletonImg(max(1,min(row+maxN-1,height)),col) = 100;
                    temYval = maxVal;
                end
            end
        end
   
    end
end
    
end

