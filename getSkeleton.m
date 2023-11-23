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

%% ��˹�˲�
h = fspecial('gaussian', [5 5], sigma);
grayImage = imfilter(grayImage,h,'same');
%% ����ͼ����ݶ�
[Gx,Gy] = gradient(double(grayImage));
Gx = abs(Gx);
Gy = abs(Gy);
%% ����Ӱ��Ǽ���ȡ��������������
w = 10;%����������ݶȵ����򳤶�
threshold = 5; %�����޳�΢С�仯�����ڵ�����ݶ�ֵ

%% ���з���x���ϵı�
for row = 1:height
    temXval = 0;
    for col = 1:1:width
        if (col+w-1)<=width
            [maxVal,maxN] = max(Gx(row,col:col+w-1));
            [minVal,minN] = min(Gx(row,col:col+w-1));
            if (maxVal-minVal) >= threshold  
                if maxVal>temXval & col>1   %���Ե�ǰ����ݶ�ֵ�Ƿ������һ������ݶ�ֵ�����ǣ�����һ�������ݶ�ֵ��Ӧ�����ص���������Ϊ0
                    skeletonImg(row,col+maxN-2) = 0;
                    skeletonImg(row,col+maxN-1) = 100;
                    temXval = maxVal;
                end
            end
        end
   
    end
end

%% ���з���y���ı�
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

