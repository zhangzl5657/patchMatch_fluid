function [ Ix,Iy ] = IGradForHOG(img)
%UNTITLED2 Summary of this function goes here
% ��ͼ���ݶ� for hog
%   Detailed explanation goes here
if size(img,3) >1 %�Ҷȴ���
    img = rgb2gray(img);
end
img = im2double(img);
img=sqrt(img);      %٤��У��

%���������Ե
fy=[-1 0 1];        %������ֱģ��
fx=fy';             %����ˮƽģ��
Iy=imfilter(img,fy,'replicate');    %��ֱ��Ե
Ix=imfilter(img,fx,'replicate');    %ˮƽ��Ե
end

