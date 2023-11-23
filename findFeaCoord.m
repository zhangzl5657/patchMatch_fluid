function [ FeaCoord,countNoCorr,flag] = findFeaCoord( BBS,FeaCorrMat,szI,szT,pz,countNoCorr)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
%  FeaCoord:存储匹配特征块（patch）在目标图像中的位置。
%  countNoCorr记录有多少个区域没找到对应的目标（即，匹配的patch数比较少）

%  flag:标记是否找到对应区域
%寻找最佳对应的区域
[val,ind]=max(BBS(:));
%% 显示匹配的比率，1为区域所包含的patch完全匹配，0为完全不匹配
%fprintf('matching number is %d\n',val);
% 将最大值得索引转换成二维坐标值
[y,x]=ind2sub(size(BBS),ind);
% 提取特征对应矩阵
N=(szT(1)/pz)*(szT(2)/pz);
feaCorr=reshape(FeaCorrMat(y,x,:),[N,N]);
FeaCoord=zeros(N,2);

%% 判断最佳匹配的块数的比率是否大于给定值0-1，若小于则退出。
if val<0.6
%     fprintf('the number of best-buddies is %d \n',val);
    countNoCorr = countNoCorr+1;
    flag = 0;
    return;
end
%% 寻找匹配的小patch在图像中的坐标，FeaCoord矩阵中每一行对应一个特征块的坐标，共N行，若没有对应的特征块，坐标为（0,0）.
%tempR记录小patch的半径
tempR=floor(pz/2);
rowN = floor(szT(1)/pz);
for i=1:N
  [val,ind]=max(feaCorr(:,i));
  %初始化块的对应目标块的坐标
  fy = 0;
  fx = 0;
  if val>0
        row = mod(ind,rowN);
        col = floor(ind/rowN);
        if row == 0
            row = rowN;
            col = col-1;
        end
        fy=(y-1)*pz+(row-1)*pz+tempR+1;
        fx=(x-1)*pz+col*pz+tempR+1;
  end
  FeaCoord(i,:)=[fy,fx];
end
flag = 1;
end

