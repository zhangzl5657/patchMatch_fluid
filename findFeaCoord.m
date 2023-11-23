function [ FeaCoord,countNoCorr,flag] = findFeaCoord( BBS,FeaCorrMat,szI,szT,pz,countNoCorr)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
%  FeaCoord:�洢ƥ�������飨patch����Ŀ��ͼ���е�λ�á�
%  countNoCorr��¼�ж��ٸ�����û�ҵ���Ӧ��Ŀ�꣨����ƥ���patch���Ƚ��٣�

%  flag:����Ƿ��ҵ���Ӧ����
%Ѱ����Ѷ�Ӧ������
[val,ind]=max(BBS(:));
%% ��ʾƥ��ı��ʣ�1Ϊ������������patch��ȫƥ�䣬0Ϊ��ȫ��ƥ��
%fprintf('matching number is %d\n',val);
% �����ֵ������ת���ɶ�ά����ֵ
[y,x]=ind2sub(size(BBS),ind);
% ��ȡ������Ӧ����
N=(szT(1)/pz)*(szT(2)/pz);
feaCorr=reshape(FeaCorrMat(y,x,:),[N,N]);
FeaCoord=zeros(N,2);

%% �ж����ƥ��Ŀ����ı����Ƿ���ڸ���ֵ0-1����С�����˳���
if val<0.6
%     fprintf('the number of best-buddies is %d \n',val);
    countNoCorr = countNoCorr+1;
    flag = 0;
    return;
end
%% Ѱ��ƥ���Сpatch��ͼ���е����꣬FeaCoord������ÿһ�ж�Ӧһ������������꣬��N�У���û�ж�Ӧ�������飬����Ϊ��0,0��.
%tempR��¼Сpatch�İ뾶
tempR=floor(pz/2);
rowN = floor(szT(1)/pz);
for i=1:N
  [val,ind]=max(feaCorr(:,i));
  %��ʼ����Ķ�ӦĿ��������
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

