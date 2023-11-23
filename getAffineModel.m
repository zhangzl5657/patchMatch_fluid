function [ affineModel ] = getAffineModel( regionFeaCoord_X,regionFeaCoord_Y,regionRow,regionCol,regionSize_r,regionSize_c,pz,i1RotN,i2RotN )
%UNTITLED3 Summary of this function goes here
% A*x=b
% i1RotN:Դ���˳ʱ����ת����
% i2RotN:Ŀ����˳ʱ����ת����
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

%% ����LBPȷ����ת��Ŀ��������תʹ����Դ���Ӧ��Դ�鲻��ת��
%ȷ����ת����
rotN = i2RotN-i1RotN;
%������ת����
regionFeaCoord_X = rotMatrix(regionFeaCoord_X,rotN );
regionFeaCoord_Y = rotMatrix(regionFeaCoord_Y,rotN );

b = [regionFeaCoord_X(:),regionFeaCoord_Y(:),ones(rowI*colI,1)]';
%% ����QR�ֽⷨ��������С��������
[Q,R]=qr(A);
f=Q'*b;
affineModel=R\f;

end

