function [ affMatrix ] = getAffineMatrix(I1,pz,pixelCorrCoord_Y,pixelCorrCoord_X )
%UNTITLED2 Summary of this function goes here
% I1,I2大小需要能被pz整除
% （a1 a2 a3
%   a4 a5 a6
%    0  0  1）
% affMatrix: 存放每个patch对应的仿射变换矩阵
%   Detailed explanation goes here



[height,width,dim] = size(I1);
if mod(height,pz) ~=0 || mod(width,pz) ~=0
    disp('the size of I1 is error');
    return;
else
    pz_H = height/pz;
    pz_W = width/pz;
end

% 初始化仿射变换矩阵，每个patch对应一个仿射变换矩阵,最后一个元素为
% 0表示已经求得变换矩阵，为1则表示还未求得。 
affMatrix = zeros(pz_H,pz_W,10); 

r = floor(pz/2);
num = pz*pz;
A = ones(num,3);
inVal = zeros(3,1);
bX = ones(num,1);
bY = ones(num,1);

% 调用SOR进行求解，初始化迭代次数max_it， 放松稀疏w，和错误容忍度tol
max_it = 500;
w = 0.8;
tol = 1e-8*ones(3,1);

for col = 1:pz:height-pz+1
    for row =1:pz:width-pz+1
        % 将像素位置转换为块的位置
        pz_y = floor(col/pz)+1;
        pz_x = floor(row/pz)+1;
        
       % 如果当前块已找到对应位置，则生成仿射变换矩阵
        if pixelCorrCoord_Y(col+r,row+r) >0 || pixelCorrCoord_X(col+r,row+r) >0 
             % 构造矩阵A，形式为（X,Y,1）
            col_X = [row:row+pz-1]';
            A(:,1) = repmat(col_X,pz,1);
            for i =1:pz
                A((i-1)*pz+1:i*pz,2) = col+i-1;
            end 
            %构造bX,bY
            ind = 0; % 指示b中的第几个元素
            for y = col:col+pz-1
                for x = row:row+pz-1
                    ind = ind +1;
                    bX(ind) = pixelCorrCoord_X(y,x);
                    bY(ind) = pixelCorrCoord_Y(y,x);
                end
            end
           % 用SOR迭代求解仿射变换矩阵中A*c1=bX ,A*c2=bY,
           newA = A'*A; %将A转换为方阵
           newBX = A'*bX;
           newBY = A'*bY;
            [c1, error, iter, flag]  = sor(newA,inVal, newBX, w, max_it, tol);
            [c2, error, iter, flag]  = sor(newA,inVal, newBY, w, max_it, tol);
            c3 = [0 0 1]';
            C = [c1,c2,c3]'; %构造仿射变换矩阵[c1,c2,c3]'
            affMatrix(pz_y,pz_x,1:9) = C(:);
            affMatrix(pz_y,pz_x,10) = 1; % 设置此patch已经求得变换矩阵
        end
    
    end %end for 内
end % end for 外

end

