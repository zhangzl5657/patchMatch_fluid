% ---------------------------------
%          BBS demo script
% ---------------------------------
close all; clear; clc;
%%
if (~isdeployed)
    addpath(genpath('utils'));
end
addpath('mex');

%% set BBS params
% gamma = 2; % weighing coefficient between Dxy and Drgb
% pz = 3; % non-overlapping patch size used for pixel descirption
% pnCol=7; %��������������з���(x)�������ٸ�Сpath
% pnRow=7; %��������������з���(y)�������ٸ�Сpath
% dataDir ='..\smoke';
% Inumber = 1;

for Inumber = 4 : 4
%%
if (~isdeployed)
    addpath(genpath('utils'));
end
addpath('mex');

%% set BBS params
gamma = 2; % weighing coefficient between Dxy and Drgb
pz = 3; % non-overlapping patch size used for pixel descirption
pnCol=9; %��������������з���(x)�������ٸ�Сpath
pnRow=9; %��������������з���(y)�������ٸ�Сpath
dataDir ='..\smoke';
%% load images and target location
%[I,Iref,T,rect,rectGT] = loadImageAndTemplate(1,dataDir);
%% load ԭͼ��Iref����һ֡ͼ�񣩺�Ŀ��ͼ��I���ڶ�֡ͼ��
% [I,Iref] = loadImage(1,dataDir); % smoke ��copmuteBBS_me�н���ǰ������
% [I,Iref] = loadImage(0,dataDir); % satellite image \ sea of clouds \ sateImage \ clouds
% [I,Iref] = loadImage(3,dataDir); % smoke32
% [I,Iref] = loadImage(0,dataDir); % smoke025
% [I,Iref] = loadImage(3,dataDir); %genSmoke32-33.jpg
% [I,Iref] = loadImage(6,dataDir); %genSmoke62-63.jpg
[I,Iref] = loadImage(0,dataDir); %cloudv01.jpg
%% ����Ŀ��λ��
% rectGT = loadTargetLocation(1,dataDir);
%% adjust image and template size so they are divisible by the patch size 'pz'
[I,Iref] = adjustImageSize(I,Iref,pz);
szI = size(I);
szIref = size(Iref);

%% ����ÿ��ͼ����ݶ�ͼ  ��������HOG����
[I1dx,I1dy] = IGradForHOG(I);
[I2dx,I2dy] = IGradForHOG(Iref);
%% ���ɵ�һ֡ͼ��Ŀ飨patch���ڵڶ�֡ͼ���ж�Ӧ�Ŀ�����������ɵľ��� 
% ����ÿ����������Ĵ�С
colLen=pz*pnCol;
rowLen=pz*pnRow;
% ��ʼ����һ֡����ͼ����ÿ��С3*3patch����Ӧ���ڵڶ�֡ͼ���е�λ������Ĵ洢����
imageFeaCoord_X = zeros(floor(szIref(1)/rowLen)*pnRow,floor(szIref(2)/colLen)*pnCol);
imageFeaCoord_Y = imageFeaCoord_X;

% ָ��һ��ȷ��������й��ܲ���
% T=Iref(180:180+rowLen-1,290:290+colLen-1,:);
% szT = size(T);
% rect = [290,180,rowLen,colLen];
% [BBS,FeaCorrMat] = computeBBS(I,T,gamma, pz);

%% ѭ������ÿ�������ƥ��λ��
countNoCorr = 0;%��¼�ж��ٸ�����û����ƥ��
regionNum = 0;

for colI=1:colLen:szIref(2)-colLen
    for rowI=1:rowLen:szIref(1)-rowLen
       %���ɵ�һ֡ͼ���е��ض���������
        T=Iref(rowI:rowI+rowLen-1,colI:colI+colLen-1,:);
        szT = size(T);
        regionNum = regionNum+1;
        
        % ��ȡIref�ض�������ݶ�
        Tx = I2dx(rowI:rowI+rowLen-1,colI:colI+colLen-1);
        Ty = I2dy(rowI:rowI+rowLen-1,colI:colI+colLen-1);
%% run BBS
%tic;
       %[BBS,FeaCorrMat] = computeBBS(I,T,gamma, pz);
       [BBS,FeaCorrMat] = computeBBS_me(I,T,gamma,pz,rowI,colI,I1dx,I1dy,Tx,Ty);
       
       %% ��ʾ���Ҷ����ͽ��Ŀ���
       %interpolate likelihood map back to image size 
%         BBS = BBinterp(BBS, szT(1:2), pz, NaN);
%        [rectOut] = findTargetLocation(BBS,'max',[colLen,rowLen]);
%        subplot(2,2,1);imshow(Iref) ;
% 
%        rect = [colI,rowI,rowLen,colLen];
%       
%        rectangle('position',rect   ,'linewidth',2,'edgecolor',[0,1,0]);colorbar;title('Reference image');
%        rectangle('position',rectOut   ,'linewidth',2,'edgecolor',[1,0,0]);colorbar;title('Reference image');
%% ���ƥ��������Ŀ��ͼ���е����꣬BBSΪδ��ֵ��BBS
        [FeaCoord,countNoCorr,flag] = findFeaCoord(BBS,FeaCorrMat,szI,szT,pz,countNoCorr);
%% ����õ�ÿ��������������Ķ�Ӧ����������洢������ͼ������������������
        if flag == 1
             [imageFeaCoord_X,imageFeaCoord_Y]  = getImageFeaCoord(szT,FeaCoord,colI,rowI,pz,imageFeaCoord_X,imageFeaCoord_Y);
        end
    end
end


%% display initial patch matches չʾ��ƥ����
matchCount = showMatch( Iref,I,imageFeaCoord_X,imageFeaCoord_Y,pz);

%% ����patch�Ķ�Ӧ��ϵ��ֵ����ԭͼ����ÿ��������Ŀ�������еĶ�Ӧ�������
%[pixelCorrCoord_Y,pixelCorrCoord_X] = interpPixelCoord(szI,imageFeaCoord_X,imageFeaCoord_Y,pz);
[pixelCorrCoord_Y,pixelCorrCoord_X]= affinPixelCoord(szI,imageFeaCoord_X,imageFeaCoord_Y,pz,Iref,I);

%% ���ɷ���任����
affMatrix = getAffineMatrix(Iref,pz,pixelCorrCoord_Y,pixelCorrCoord_X);
%% չʾ��ʼ����任����
noAffPatchNum = showAffineMatrix(affMatrix,Iref);
%% ��ֵ����任�������ɶ�Ӧλ��
[affMatrix,pixelCorrCoord_Y,pixelCorrCoord_X] = interAffTran(pz,affMatrix,pixelCorrCoord_Y,pixelCorrCoord_X );

%% չʾ��ֵ��ķ���任����
noAffPatchNum2 = showAffineMatrix(affMatrix,I);
%% ����λ��
[dis_Y,dis_X] = getDis(szI,pixelCorrCoord_Y,pixelCorrCoord_X);

quiver(dis_X,dis_Y);
axis ij;
%% ƽ���˲�
% h=fspecial('gaussian',[10 10],1.5); % for smoke
% h=fspecial('gaussian',[10 10],5); % for cloud
h=fspecial('gaussian',[5 5],0.6); % for smoke
fdx = dis_X;
fdy = dis_Y;
for i=1:3
    fdx=imfilter(fdx,h,'replicate');
    fdy=imfilter(fdy,h,'replicate');
end
dis_X = fdx;
dis_Y = fdy;
%% ƽ������
[vx,vy]=smoothFlow(Iref,I,dis_X,dis_Y);
%% ������ƽ������
% vx = dis_X;
% vy = dis_Y;
%% ������
% save mevx vx;
% save mevy vy;
%% չʾ����
flow(:,:,1) = vx;
flow(:,:,2) = vy;
% 
% figure(1); quiver(vy, vx) ;
% axis ij ;
% 
flowImg = uint8(flowToColor(flow));

%% calculate interpolation error
[warpI,errorVal] = calIE(Iref,I,vx,vy);

%%
% %% ������ʾĿ������frect2
% frect2=[FeaCoord(2,2)-1,FeaCoord(2,1)-1,3,3];
% 
% %% interpolate likelihood map back to image size 
% BBS = BBinterp(BBS, szT(1:2), pz, NaN);
% t = toc;
% fprintf('BBS computed in %.2f sec (|I| = %dx%d , |T| = %dx%d)\n',t,szI(1:2),szT(1:2));
% 
% %% find target position in image (max BBS)
% [rectOut] = findTargetLocation(BBS,'max',rect(3:4));
% 
% %% compute overlap with ground-truth
% ol = rectOverlap(rectCorners(rectGT),rectCorners(rectOut));
% 
% %% plot results
% figure(1);clf;
% subplot(2,2,1);imshow(Iref) ;
% rectangle('position',rect   ,'linewidth',2,'edgecolor',[0,1,0]);colorbar;title('Reference image');
% 
% 
% 
% subplot(2,2,2);imshow(I)    ;hold on;
% rct(1) = rectangle('position',rectGT,'linewidth',2,'edgecolor',[0,1,0]);
% plt(1) = plot(nan,nan,'s','markeredgecolor',get(rct(1),'edgecolor'),'markerfacecolor',get(rct(1),'edgecolor'),'linewidth',3); leg{1} = 'GT';
% rct(2) = rectangle('position',rectOut,'linewidth',2,'edgecolor',[1,0,0]);
% plt(2) = plot(nan,nan,'s','markeredgecolor',get(rct(2),'edgecolor'),'markerfacecolor',get(rct(2),'edgecolor'),'linewidth',3); leg{2} = 'BBS';
% %% ��ʾ�ҵ��Ķ�Ӧ����
% rectangle('position',frect2,'linewidth',1,'edgecolor',[0,0,1]);
% 
% legend(plt,leg,'location','southeast');set(gca,'fontsize',12);
% colorbar;title({'Query image',sprintf('Overlap = %.2f',ol)});
% subplot(2,2,3);imagesc(BBS) ;rectangle('position',rectOut,'linewidth',2,'edgecolor',[1,0,0]);colormap jet;axis image;colorbar;title('BBS score');

%% printf some statistic results 
fprintf('region number=%d    the number of no corresponding=%d\n',regionNum,countNoCorr);
fprintf('the interpolation error is %f  \n',errorVal);
%% ��ʾ����������
figure;

% subplot(2,3,1); imagesc(pixelCorrCoord_Y);
% subplot(2,3,2); imagesc(pixelCorrCoord_X);
% subplot(2,3,3); imagesc(imageFeaCoord_Y);
% subplot(2,3,4); imagesc(imageFeaCoord_X);

% subplot(1,2,1); imshow(Iref);
% subplot(1,2,2); 
imshow(flowImg);

%% plot vector old %%
% figure; 
% % imshow(Iref);
% hold on;
% density = 12;
% [maxI,maxJ]=size(vx);
% Dx=vx(maxI:-density:1,1:density:maxJ);
% Dy=vy(maxI:-density:1,1:density:maxJ);
% % quiver(1:density:maxJ,(maxI):(-density):1,Dx,Dy,1); % ��ͼ�������ʾʱ��
% quiver(1:density:maxJ,(maxI):(-density):1,Dx,-Dy,1,'b'); % ֻ��ʾ������ʱ��
% hold off;
% % outputName = sprintf('./seacloud-output/imgvelocity%d',Inumber);
% % print(2,outputName,'-dpng');


%% plot vector new%%
figure; 
% imshow(Iref);
hold on;
density = 12;
[maxI,maxJ]=size(vx);
Dx=vx(1:density:maxI,1:density:maxJ);
Dy=vy(1:density:maxI,1:density:maxJ);
% quiver(1:density:maxJ,1:(density):maxI,Dx,Dy,1,'r'); % ��ͼ�������ʾʱ��
quiver(1:density:maxJ,(maxI):(-density):1,Dx,-Dy,1,'b'); % ֻ��ʾ������ʱ��
hold off;
outputName = sprintf('./satellite-output/imgvelocity%d',Inumber);
print(2,outputName,'-dpng');
%% display the warping image of I1 using the velocity
figure;
imshow(warpI);
%subplot(1,2,1); imshow(warpI/255);
% subplot(1,2,1); imshow(warpI);
imwrite(warpI,'./output/wapCloud.jpg','jpg');
% subplot(1,2,2); imshow(I);
%% display interpolation error image
showImageErr(I,warpI);

%%
% close all; clear; clc;
end % for