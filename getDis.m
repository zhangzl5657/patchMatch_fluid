function [ dis_Y,dis_X ] = getDis( szI,pixelCorrCoord_Y,pixelCorrCoord_X )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
dis_Y = zeros(szI(1),szI(2));
dis_X = dis_Y;
for col=1:szI(2)
    for row=1:szI(1)
        if pixelCorrCoord_Y(row,col)>0 && pixelCorrCoord_X(row,col)>0
            dis_Y(row,col) = pixelCorrCoord_Y(row,col) - row;
            dis_X(row,col) = pixelCorrCoord_X(row,col) - col;
        end
    end
end

end

