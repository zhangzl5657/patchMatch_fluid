function [ rotM ] = rotMatrix( M,rotN )
%UNTITLED Summary of this function goes here
% ʵ��3*3��������ȦԪ������ѭ����λrotN
% rotNΪ����ʱΪ˳ʱ����λ��Ϊ����ʱΪ��ʱ����λ
%   Detailed explanation goes here

% �趨3*3������ȦԪ�ظ���Ϊ8
n = 8;
vectorM = zeros(n,1);
%% ������M����ȦԪ���г�����������ֵ��vectorM
vectorM(1:3) = M(1,:);
vectorM(4) = M(2,3);
vectorM(5:7) = M(3,3:-1:1);
vectorM(8) = M(2,1);
%% ��ת����vectorM
vectorM = circshift(vectorM,rotN);

%% ����ת�������vectroM��ֵ��M����ȦԪ��
M(1,:) = vectorM(1:3);
M(2,3) = vectorM(4);
M(3,:) = vectorM(7:-1:5);
M(2,1) = vectorM(8);

%% ���ؽ��
rotM = M;

end

