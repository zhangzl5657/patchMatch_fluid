function [pixelCorrCoord_Y,pixelCorrCoord_X] = interpPixelCoord(szI,imageFeaCoord_X,imageFeaCoord_Y,pz)
%UNTITLED Summary of this function goes here
% pixelCorrCoord_Y:�洢Դͼ����ÿ�����ص���Ŀ��ͼ���ж�Ӧ�����ص��Y����
% pixelCorrCoord_X:�洢Դͼ����ÿ�����ص���Ŀ��ͼ���ж�Ӧ�����ص��X����
%   Detailed explanation goes here

pixelCorrCoord_Y = zeros(szI(1),szI(2));
pixelCorrCoord_X = pixelCorrCoord_Y;

%% ����������Ӧ�����ֵΪ���ض�Ӧ����
szFC = size(imageFeaCoord_X);
pr = floor(pz/2); %����patch�İ뾶
for colI=1:szFC(2)
    for rowI=1:szFC(1)
        cx = (colI-1)*pz+pr+1; %patch���ĵ�x����
        cy = (rowI-1)*pz+pr+1; %patch���ĵ�����
        ltx = (colI-1)*pz+1;  %patch���Ͻǵ�x����
        lty = (rowI-1)*pz+1;  %patch���Ͻǵ�y����
        for x=ltx:ltx+pz-1
            for y=lty:lty+pz-1
                pixelCorrCoord_Y(y,x) = imageFeaCoord_Y(rowI,colI)+(y-cy);
                pixelCorrCoord_X(y,x) = imageFeaCoord_X(rowI,colI)+(x-cx);
            end
        end
   end
end

end

