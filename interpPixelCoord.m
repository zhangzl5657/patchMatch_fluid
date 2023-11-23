function [pixelCorrCoord_Y,pixelCorrCoord_X] = interpPixelCoord(szI,imageFeaCoord_X,imageFeaCoord_Y,pz)
%UNTITLED Summary of this function goes here
% pixelCorrCoord_Y:存储源图像中每个像素点在目标图像中对应的像素点的Y坐标
% pixelCorrCoord_X:存储源图像中每个像素点在目标图像中对应的像素点的X坐标
%   Detailed explanation goes here

pixelCorrCoord_Y = zeros(szI(1),szI(2));
pixelCorrCoord_X = pixelCorrCoord_Y;

%% 将块特征对应坐标插值为像素对应坐标
szFC = size(imageFeaCoord_X);
pr = floor(pz/2); %计算patch的半径
for colI=1:szFC(2)
    for rowI=1:szFC(1)
        cx = (colI-1)*pz+pr+1; %patch中心的x坐标
        cy = (rowI-1)*pz+pr+1; %patch中心的坐标
        ltx = (colI-1)*pz+1;  %patch左上角的x坐标
        lty = (rowI-1)*pz+1;  %patch左上角的y坐标
        for x=ltx:ltx+pz-1
            for y=lty:lty+pz-1
                pixelCorrCoord_Y(y,x) = imageFeaCoord_Y(rowI,colI)+(y-cy);
                pixelCorrCoord_X(y,x) = imageFeaCoord_X(rowI,colI)+(x-cx);
            end
        end
   end
end

end

