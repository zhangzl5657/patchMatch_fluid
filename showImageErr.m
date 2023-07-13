function showImageErr( I1,I2 )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
err = abs(double(I1)-double(I2))/255; %smoke:photo1.jpg
errImg = sum(err,3);
figure
axis off;
imagesc(errImg);
colorbar;
end


