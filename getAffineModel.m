function [ affineModel ] = getAffineModel( regionFeaCoord_X,regionFeaCoord_Y,regionRow,regionCol,regionSize_r,regionSize_c,pz,i1RotN,i2RotN )
%UNTITLED3 Summary of this function goes here
% A*x=b
% i1RotN:源块的顺时针旋转次数
% i2RotN:目标块的顺时针旋转次数
%   Detailed explanation goes here

[rowI,colI]=size(regionFeaCoord_X);
patchR = floor(pz/2);
A = ones(3,rowI*colI);
count = 0;
for col=regionCol:regionCol+regionSize_c-1
    for row=regionRow:regionRow+regionSize_r-1
        count = count+1;
        y=(row-1)*pz+patchR+1;
        x=(col-1)*pz+patchR+1;
        A(1,count) = x;
        A(2,count) = y;
    end
end

%% 根据LBP确定旋转将目标块进行旋转使得与源块对应（源块不旋转）
%确定旋转次数
rotN = i2RotN-i1RotN;
%进行旋转操作
regionFeaCoord_X = rotMatrix(regionFeaCoord_X,rotN );
regionFeaCoord_Y = rotMatrix(regionFeaCoord_Y,rotN );

b = [regionFeaCoord_X(:),regionFeaCoord_Y(:),ones(rowI*colI,1)]';
%% 利用QR分解法求线性最小二乘问题
[Q,R]=qr(A);
f=Q'*b;
affineModel=R\f;

end

