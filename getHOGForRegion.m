function [ HOGM ] = getHOGForRegion( Ix, Iy, pz )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

sz = size(Ix);
mi = mod(sz(1:2),pz);
if(any(mi))
   fprintf('The image and template should be divided by the patch size');
   return;
end

Ied=sqrt(Ix.^2+Iy.^2);              %��Եǿ��
Iphase=Iy./Ix;              %��Եб�ʣ���ЩΪinf,-inf,nan������nan��Ҫ�ٴ���һ��

step=pz;                %step*step��������Ϊһ����Ԫ
orient=9;               %����ֱ��ͼ�ķ������
jiao=360/orient;        %ÿ����������ĽǶ���
% Cell=cell(1,1);              %���еĽǶ�ֱ��ͼ,cell�ǿ��Զ�̬���ӵģ�����������һ��
HOGM = zeros(sz(1)/pz,sz(2)/pz,orient); 
ii=1;                      
jj=1;
for i=1:step:sz(1)          %��������m/step���������������i=1:step:m-step
    jj=1;
    for j=1:step:sz(2)      %ע��ͬ��
        tmpx=Ix(i:i+step-1,j:j+step-1);
        tmped=Ied(i:i+step-1,j:j+step-1);
        tmped=tmped/sum(sum(tmped));        %�ֲ���Եǿ�ȹ�һ��
        tmpphase=Iphase(i:i+step-1,j:j+step-1);
        Hist=zeros(1,orient);               %��ǰstep*step���ؿ�ͳ�ƽǶ�ֱ��ͼ,����cell
        for p=1:step
            for q=1:step
                if isnan(tmpphase(p,q))==1  %0/0��õ�nan�����������nan������Ϊ0
                    tmpphase(p,q)=0;
                end
                ang=atan(tmpphase(p,q));    %atan�����[-90 90]��֮��
                ang=mod(ang*180/pi,360);    %ȫ��������-90��270
                if tmpx(p,q)<0              %����x����ȷ�������ĽǶ�
                    if ang<90               %����ǵ�һ����
                        ang=ang+180;        %�Ƶ���������
                    end
                    if ang>270              %����ǵ�������
                        ang=ang-180;        %�Ƶ��ڶ�����
                    end
                end
                ang=ang+0.0000001;          %��ֹangΪ0
                Hist(ceil(ang/jiao))=Hist(ceil(ang/jiao))+tmped(p,q);   %ceil����ȡ����ʹ�ñ�Եǿ�ȼ�Ȩ
            end
        end
        %Hist=Hist/sum(Hist);    %����ֱ��ͼ��һ������һ������û�У���Ϊ�����block�Ժ��ٽ��й�һ���Ϳ���
%         Cell{ii,jj}=Hist;       %����Cell��
        HOGM(ii,jj,:)=Hist;
        jj=jj+1;                %���Cell��y����ѭ������
    end
    ii=ii+1;                    %���Cell��x����ѭ������
end

end

