function [BBS,FeaCorrMat] = computeBBS_me(I,T,gamma, pz,locationY,locationX,I1dx,I1dy,Tx,Ty)
%------------
%在目标区域所在的领域内寻找最佳匹配对
%BBS:存储每个位置（colI，rowI）对应的检索区域内有多少个特征点匹配
%FeaCorrMat:存储每个位置（colI，rowI）对应的检索区域内相互匹配的特征点之间的对应关系
%--------------
szI = size(I);
szT = size(T);


mi = mod(szI(1:2),pz);
mt = mod(szT(1:2),pz);

if(any(mi) | any(mt))
   fprintf('The image and template should be divided by the patch size');
   return;
end

%% 判断是否没有进行位移（即：背景元素）
 noMotionI = I(locationY:locationY+szT(1)-1,locationX:locationX+szT(2)-1,:); 
 noMotionIx = I1dx(locationY:locationY+szT(1)-1,locationX:locationX+szT(2)-1);
 noMotionIy = I1dy(locationY:locationY+szT(1)-1,locationX:locationX+szT(2)-1);
 [BBS,FeaCorrMat] = computeNearsBBS(I,noMotionI,T,gamma,pz,floor(locationY/pz)+1,floor(locationX/pz)+1,noMotionIx,noMotionIy,Tx,Ty);
 [val,ind] = max(BBS(:));

 if val< 0.8
    % generate near-neighbor areas of searching
    nearPN = 30; %在多大的邻域内进行查找
    %%%%%%%%%%%for others%%%%%%%%%%%
    leftTopX = max(1,locationX - pz*nearPN);
    %%%%%%%%%%%%%%%%for smok1%%%%%%%%%%%%%%%%%
%     leftTopX = max(1,locationX);%for smoke1
    %%%%%%%%%%%%%%%%%%%%%%%
    leftTopY = max(1,locationY - pz*nearPN);
    rightBottomX = min(locationX+szT(2)-1+pz*nearPN,szI(2));
    rightBottomY = min(locationY+szT(1)-1+pz*nearPN,szI(1));
    searchI = I(leftTopY:rightBottomY,leftTopX:rightBottomX,:);

    searchIx = I1dx(leftTopY:rightBottomY,leftTopX:rightBottomX);
    searchIy = I1dy(leftTopY:rightBottomY,leftTopX:rightBottomX);
    % 调整searchI的大小，使得能被pz整除
    szSI = size(searchI);
    mi = mod(szSI(1:2),pz);
    if(any(mi))
        searchI = searchI(1:end-mi(1),1:end-mi(2),:); 
        searchIx = searchIx(1:end-mi(1),1:end-mi(2));
        searchIy = searchIy(1:end-mi(1),1:end-mi(2));
        
        rightBottomX = rightBottomX - min(2);
        rightBottomY = rightBottomY - min(1);
        szSI = size(searchI);
    end

    % 计算搜索区域在整个图像中的位置（以patch块为坐标，即：在区域的左上角属于图像的第几个patch）
    patchLocationX = floor(leftTopX/pz)+1; %patchLocationX 为左上角所在的X方向上的patch坐标
    patchLocationY = floor(leftTopY/pz)+1; %patchLocationY 为左上角所在的Y方向上的patch坐标
    [BBS,FeaCorrMat] = computeNearsBBS(I,searchI,T,gamma,pz,patchLocationY,patchLocationX,searchIx,searchIy,Tx,Ty);
end






