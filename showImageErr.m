function showImageErr( I1,I2 )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
err = abs(I1-I2);
errImg = sum(err,3);
figure
imagesc(errImg);
colorbar;
end

