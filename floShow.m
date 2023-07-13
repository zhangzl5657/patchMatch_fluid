function floShow( im1,im2,name)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
addpath(genpath('utils'));
% str = sprintf('.\\floData\\%s',name); %epicflow reslut
str = sprintf('.\\s2fresult\\%s',name); %s2f result
flow=readFlowFile(str);
[h,w,d] = size(flow);
vx(:,:) = flow(:,:,1);
vy(:,:) = flow(:,:,2);
%% calculate interpolation error
[warpI,errorVal] = calIE(im1,im2,vx,vy);
warpII = uint8(warpI);
Iname = sprintf('.\\output\\%s.jpg',name);
imwrite(warpII,Iname);
fprintf('the interpolation error is %f  \n',errorVal);
%% plot vector %%
figure; 
% imshow(uint8(oriIm1));
hold on;
density = 12;
[maxI,maxJ]=size(vx);
Dx=vx(1:density:maxI,1:density:maxJ);
Dy=vy(1:density:maxI,1:density:maxJ);
quiver(1:density:maxJ,(maxI):(-density):1,Dx,-Dy,1,'b');
hold off;

%% display the warping image of I1 using the velocity
figure;
imshow(uint8(warpI));
% subplot(1,2,1); imshow(uint8(warpI));
% subplot(1,2,2); imshow(uint8(im2));
%% showImageErr
showImageErr(im2, warpI);

flowImg = flowToColor(flow);
figure;
imshow(flowImg);
end



