function [pixelCorrCoord_Y,pixelCorrCoord_X] = affinPixelCoord(szI,imageFeaCoord_X,imageFeaCoord_Y,pz,I0,I1)
%UNTITLED Summary of this function goes here
% 通过仿射变换获得原图像I0中每个像素点在目标图像I1中的对应坐标
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
        % 获取I0中的源块图像
        patch_0 = I0(cy-pr:cy+pr,cx-pr:cx+pr);
        [M1,rotN1] = LBP_patch(patch_0); 
        
        % 若块找到所对应的目标区域，则根据LBP的旋转方式生成对应坐标
        cx_2 = imageFeaCoord_X(rowI,colI); %对应patch中心x坐标
        cy_2 = imageFeaCoord_Y(rowI,colI); %对应patch中心y坐标
        if imageFeaCoord_Y(rowI,colI)>0 && imageFeaCoord_X(rowI,colI)>0
           % 获取I1中的目标图像
            patch_1 = I1(cy_2-pr:cy_2+pr,cx_2-pr:cx_2+pr);
            % 获取I1中目标块的LBP值及顺时针旋转次数
            [M2,rotN2] = LBP_patch(patch_1);
           % 初始化目标块中各个元素的坐标
           coordPatch_y = zeros(pz,pz);
           coordPatch_x = coordPatch_y;
           % 生成目标块中各个元素的坐标
           for i=1:pz
               coordPatch_y(i,:) = cy_2-pr-1+i;
               coordPatch_x(:,i) = cx_2-pr-1+i;
           end
           % 获取目标块相对于源块应该旋转的次数
           rotN = rotN2-rotN1;
           rotM_Y = coordPatch_y;
           rotM_X = coordPatch_x;
           if rotN ~= 0
                rotM_Y = rotMatrix(coordPatch_y,rotN);
                rotM_X = rotMatrix(coordPatch_x,rotN);
           end
           %将旋转后的目标块的坐标赋值给源块的坐标矩阵
           pixelCorrCoord_Y(cy-pr:cy+pr,cx-pr:cx+pr) = rotM_Y;
           pixelCorrCoord_X(cy-pr:cy+pr,cx-pr:cx+pr) = rotM_X;
        end
         
   end
end
end

