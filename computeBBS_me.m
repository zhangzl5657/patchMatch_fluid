function [BBS,FeaCorrMat] = computeBBS_me(I,T,gamma, pz,locationY,locationX,I1dx,I1dy,Tx,Ty)
%------------
%��Ŀ���������ڵ�������Ѱ�����ƥ���
%BBS:�洢ÿ��λ�ã�colI��rowI����Ӧ�ļ����������ж��ٸ�������ƥ��
%FeaCorrMat:�洢ÿ��λ�ã�colI��rowI����Ӧ�ļ����������໥ƥ���������֮��Ķ�Ӧ��ϵ
%--------------
szI = size(I);
szT = size(T);


mi = mod(szI(1:2),pz);
mt = mod(szT(1:2),pz);

if(any(mi) | any(mt))
   fprintf('The image and template should be divided by the patch size');
   return;
end

%% �ж��Ƿ�û�н���λ�ƣ���������Ԫ�أ�
 noMotionI = I(locationY:locationY+szT(1)-1,locationX:locationX+szT(2)-1,:); 
 noMotionIx = I1dx(locationY:locationY+szT(1)-1,locationX:locationX+szT(2)-1);
 noMotionIy = I1dy(locationY:locationY+szT(1)-1,locationX:locationX+szT(2)-1);
 [BBS,FeaCorrMat] = computeNearsBBS(I,noMotionI,T,gamma,pz,floor(locationY/pz)+1,floor(locationX/pz)+1,noMotionIx,noMotionIy,Tx,Ty);
 [val,ind] = max(BBS(:));

 if val< 0.8
    % generate near-neighbor areas of searching
    nearPN = 30; %�ڶ��������ڽ��в���
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
    % ����searchI�Ĵ�С��ʹ���ܱ�pz����
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

    % ������������������ͼ���е�λ�ã���patch��Ϊ���꣬��������������Ͻ�����ͼ��ĵڼ���patch��
    patchLocationX = floor(leftTopX/pz)+1; %patchLocationX Ϊ���Ͻ����ڵ�X�����ϵ�patch����
    patchLocationY = floor(leftTopY/pz)+1; %patchLocationY Ϊ���Ͻ����ڵ�Y�����ϵ�patch����
    [BBS,FeaCorrMat] = computeNearsBBS(I,searchI,T,gamma,pz,patchLocationY,patchLocationX,searchIx,searchIy,Tx,Ty);
end






