function [affMatrix,pixelCorrCoord_Y,pixelCorrCoord_X] = interAffTran(pz,affMatrix,pixelCorrCoord_Y,pixelCorrCoord_X )
%UNTITLED3 Summary of this function goes here
% 仿射变换插值：为没有仿射变换的块根据其四邻域进行求解其仿射变换
%   Detailed explanation goes here
NLength = 2; %搜索的领域范围
[p_H,p_W,p_D] = size(affMatrix);
count_while = 0;
while (1)
    count_while = count_while+1;
    flag_1 = 0; % 标记是否所有块都已经插值得到仿射变换
    for py = 1:p_H
        for px = 1:p_W
            % 对未获得仿射变换矩阵的patch进行插值
            if affMatrix(py,px,10) == 0
                flag_1 = flag_1+1;
               % 插值生成仿射变换矩阵

               %确定搜索区间
               minY = max(1,py-NLength); 
               maxY = min(p_H,py+NLength);
               minX = max(1,px-NLength);
               maxX = min(p_W,px+NLength);
               sumW = 0;
               tempMat = zeros(3,3);
               flag_2 = 0; %标记领域内有几个块已经获得在仿射变换矩阵
               for y = minY:maxY
                   for x = minX:maxX
                       if affMatrix(y,x,10) == 1
                           flag_2 = flag_2+1;
                           d = sqrt((py-y)^2+(px-x)^2);
                           currMat = affMatrix(y,x,1:9);
                           currMat = reshape(currMat,[3,3]);
                           tempMat = tempMat + exp(-1*d)*currMat;
                           sumW = sumW + exp(-1*d);  
                       end
                   end
               end
               
               if flag_2 > 5 % there is more than 5 neighbors for the patch
                   tempMat = (1/(sumW+1e-8))*tempMat;
                   tempMat(3,3) = 1;
                   affMatrix(py,px,1:9) = tempMat(:);
                   affMatrix(py,px,10) = 2; %表示由插值得到的仿射变换矩阵

                   % 根据仿射变换生成坐标 A*x=b
                   for px_X = (px-1)*pz+1:px*pz
                       for px_Y = (py-1)*pz+1:py*pz
                           vec = [px_X px_Y 1]';
                           b = tempMat*vec;
                           pixelCorrCoord_X(px_Y,px_X) = b(1);
                           pixelCorrCoord_Y(px_Y,px_X) = b(2);
                       end
                   end
               end % end if

            end
        end
    end % end for py
    if flag_1 >0 || count_while >100
        break;
    end
end % end while (1)
end

