function [pixelCorrCoord_Y,pixelCorrCoord_X] = affinPixelCoord(szI,imageFeaCoord_X,imageFeaCoord_Y,pz,I0,I1)
%UNTITLED Summary of this function goes here
% ͨ������任���ԭͼ��I0��ÿ�����ص���Ŀ��ͼ��I1�еĶ�Ӧ����
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
        % ��ȡI0�е�Դ��ͼ��
        patch_0 = I0(cy-pr:cy+pr,cx-pr:cx+pr);
        [M1,rotN1] = LBP_patch(patch_0); 
        
        % �����ҵ�����Ӧ��Ŀ�����������LBP����ת��ʽ���ɶ�Ӧ����
        cx_2 = imageFeaCoord_X(rowI,colI); %��Ӧpatch����x����
        cy_2 = imageFeaCoord_Y(rowI,colI); %��Ӧpatch����y����
        if imageFeaCoord_Y(rowI,colI)>0 && imageFeaCoord_X(rowI,colI)>0
           % ��ȡI1�е�Ŀ��ͼ��
            patch_1 = I1(cy_2-pr:cy_2+pr,cx_2-pr:cx_2+pr);
            % ��ȡI1��Ŀ����LBPֵ��˳ʱ����ת����
            [M2,rotN2] = LBP_patch(patch_1);
           % ��ʼ��Ŀ����и���Ԫ�ص�����
           coordPatch_y = zeros(pz,pz);
           coordPatch_x = coordPatch_y;
           % ����Ŀ����и���Ԫ�ص�����
           for i=1:pz
               coordPatch_y(i,:) = cy_2-pr-1+i;
               coordPatch_x(:,i) = cx_2-pr-1+i;
           end
           % ��ȡĿ��������Դ��Ӧ����ת�Ĵ���
           rotN = rotN2-rotN1;
           rotM_Y = coordPatch_y;
           rotM_X = coordPatch_x;
           if rotN ~= 0
                rotM_Y = rotMatrix(coordPatch_y,rotN);
                rotM_X = rotMatrix(coordPatch_x,rotN);
           end
           %����ת���Ŀ�������긳ֵ��Դ����������
           pixelCorrCoord_Y(cy-pr:cy+pr,cx-pr:cx+pr) = rotM_Y;
           pixelCorrCoord_X(cy-pr:cy+pr,cx-pr:cx+pr) = rotM_X;
        end
         
   end
end
end

