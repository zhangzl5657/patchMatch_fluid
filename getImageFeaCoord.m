function [imageFeaCoord_X,imageFeaCoord_Y ] = getImageFeaCoord(szT,templateFeaCoord,colI,rowI,pz,tempImageFeaCoord_X,tempImageFeaCoord_Y)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

%% ����ģ��������ٸ�Сpatch
rowN=szT(1)/pz; %y����������ٸ�Сpatch
colN=szT(2)/pz; %x����������ٸ�Сpatch
N=rowN*colN;

%% ����ǰģ����������Ķ�Ӧ�����ŵ�ȫ��������Ӧ������
for i=1:N
    row = mod(i,rowN);   %������������������y������
    col = floor(i/rowN); %������������������x������
    if row == 0
        row = rowN;
        col = col-1;
    end
    fy = floor(rowI/pz)+row;
    fx = floor(colI/pz)+col+1;
    tempImageFeaCoord_Y(fy,fx) = templateFeaCoord(i,1);
    tempImageFeaCoord_X(fy,fx) = templateFeaCoord(i,2);
end
%% ��������ͼ��Ŀ�������Ӧ�������imageFeaCoord
imageFeaCoord_X = tempImageFeaCoord_X;
imageFeaCoord_Y = tempImageFeaCoord_Y;
end

