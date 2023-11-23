function alphaImg = getalphaImg( img )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
if(size(img,3)>1)
    img_g = rgb2gray( img ) ;
else
    img_g = img;
end
[ix, iy] = imgGrad( img_g ) ;

alphaImg = exp(-5*sqrt((ix .^ 2 + iy .^ 2))) ;


% if nargin < 2
% 	alpha_cov = 2.0 ;
% end
% 
% if(size(img,3)>1)
%     img_g = rgb2gray( img ) ;
% else
%     img_g = img;
% end
% 
% [ix, iy] = imgGrad( img_g ) ;
% 
% alphaImg = ix .^ 2 + iy .^ 2 ;
% alphaImg = exp( -alphaImg / ( 2 * alpha_cov .^ 2 ) ) ;
% alphaImg = alphaImg / sqrt( 2 * pi * alpha_cov .^ 2 ) ;
end

