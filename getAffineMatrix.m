function [ affMatrix ] = getAffineMatrix(I1,pz,pixelCorrCoord_Y,pixelCorrCoord_X )
%UNTITLED2 Summary of this function goes here
% I1,I2��С��Ҫ�ܱ�pz����
% ��a1 a2 a3
%   a4 a5 a6
%    0  0  1��
% affMatrix: ���ÿ��patch��Ӧ�ķ���任����
%   Detailed explanation goes here



[height,width,dim] = size(I1);
if mod(height,pz) ~=0 || mod(width,pz) ~=0
    disp('the size of I1 is error');
    return;
else
    pz_H = height/pz;
    pz_W = width/pz;
end

% ��ʼ������任����ÿ��patch��Ӧһ������任����,���һ��Ԫ��Ϊ
% 0��ʾ�Ѿ���ñ任����Ϊ1���ʾ��δ��á� 
affMatrix = zeros(pz_H,pz_W,10); 

r = floor(pz/2);
num = pz*pz;
A = ones(num,3);
inVal = zeros(3,1);
bX = ones(num,1);
bY = ones(num,1);

% ����SOR������⣬��ʼ����������max_it�� ����ϡ��w���ʹ������̶�tol
max_it = 500;
w = 0.8;
tol = 1e-8*ones(3,1);

for col = 1:pz:height-pz+1
    for row =1:pz:width-pz+1
        % ������λ��ת��Ϊ���λ��
        pz_y = floor(col/pz)+1;
        pz_x = floor(row/pz)+1;
        
       % �����ǰ�����ҵ���Ӧλ�ã������ɷ���任����
        if pixelCorrCoord_Y(col+r,row+r) >0 || pixelCorrCoord_X(col+r,row+r) >0 
             % �������A����ʽΪ��X,Y,1��
            col_X = [row:row+pz-1]';
            A(:,1) = repmat(col_X,pz,1);
            for i =1:pz
                A((i-1)*pz+1:i*pz,2) = col+i-1;
            end 
            %����bX,bY
            ind = 0; % ָʾb�еĵڼ���Ԫ��
            for y = col:col+pz-1
                for x = row:row+pz-1
                    ind = ind +1;
                    bX(ind) = pixelCorrCoord_X(y,x);
                    bY(ind) = pixelCorrCoord_Y(y,x);
                end
            end
           % ��SOR����������任������A*c1=bX ,A*c2=bY,
           newA = A'*A; %��Aת��Ϊ����
           newBX = A'*bX;
           newBY = A'*bY;
            [c1, error, iter, flag]  = sor(newA,inVal, newBX, w, max_it, tol);
            [c2, error, iter, flag]  = sor(newA,inVal, newBY, w, max_it, tol);
            c3 = [0 0 1]';
            C = [c1,c2,c3]'; %�������任����[c1,c2,c3]'
            affMatrix(pz_y,pz_x,1:9) = C(:);
            affMatrix(pz_y,pz_x,10) = 1; % ���ô�patch�Ѿ���ñ任����
        end
    
    end %end for ��
end % end for ��

end

