function [ warpIC,errorVal ] = calIE( I1,I2,u,v )
%UNTITLED4 Summary of this function goes here
% compute the interpolation error = sqrt(1/N*(sum(warpI - I2)^2))
% warpI is the result of warping I1
% 
%   Detailed explanation goes here

%warpI = mywarp_rgb(I1,u,v);
warpI = warp_image(I2,u,v);
warpIC = warpI;
[h,w,d] = size(warpI);
if d > 1
    warpI = rgb2gray(warpI);
end
[h,w,d] = size(I2);
if d > 1
    I2 = rgb2gray(I2);
end

errorVal_1 = warpI - I2;
errorVal_2 = errorVal_1.^2;
errorVal_3 = sum(sum(errorVal_2));
errorVal = sqrt(errorVal_3/(h*w));

end

