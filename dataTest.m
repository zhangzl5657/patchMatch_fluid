addpath(genpath('utils'));
addpath('mex');
% dataDir ='..\smoke';
% [I,Iref] = loadImage(1,dataDir);
% I = double(rgb2gray(I));
% Iref = double(rgb2gray(Iref));
% [hei,wid,d]=size(I);
% load uvnew2.mat dis_X;
% load uvnew2.mat dis_Y;
% uu = dis_X;
% vv = dis_Y;
load uvHS.mat uv
uu = uv(:,:,1);
vv = uv(:,:,2);
% [vx,vy]=smoothFlow(Iref,I,uu,vv);




% this is the core part of calling the mexed dll file for computing optical flow
% it also returns the time that is needed for two-frame estimation
% [vx,vy] = optic_flow_optimization(I,Iref,uu,vv);
 %[vx,vy,warpI] = smoothFlow(Iref,I,uu,vv);
% 
% flow = zeros(hei,wid,2);
flow(1:size(uv,1),1:size(uv,2),1) = uu;
flow(1:size(uv,1),1:size(uv,2),2) = vv;
flowImg = flowToColor(flow);
ff = uint8(flowImg);
% subplot(2,3,1); imagesc(vv);
% subplot(2,3,2); imagesc(uu);
% subplot(2,3,3); imshow(vv);
% subplot(2,3,4); imshow(uu);
% subplot(2,3,5); imshow(warpI);
figure(4); imshow(ff);