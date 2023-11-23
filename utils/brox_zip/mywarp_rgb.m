function warpedim = mywarp_rgb( im1, u, v )

% Author: Visesh Chari <visesh [at] research.iiit.net>
% Centre for Visual Information Technology
% International Institute of Information Technology
% http://cvit.iiit.ac.in/
% http://research.iiit.ac.in/~visesh
%
% The Software is provided "as is", without warranty of any kind.
%% 使用Interp2 函数实现图像warping
% [h w d] = size(im1) ;
% 
% [uc vc] = meshgrid( 1:w, 1:h ) ;
% 
% uc1 = uc + u ;
% vc1 = vc + v ;
% 
% warpedim = zeros( size(im1) ) ;
% tmp = zeros(h, w) ;
% 
% % tmp(:) = interp2(uc, vc, double(squeeze(im1(:, :, 1))), uc1(:), vc1(:), 'bilinear') ;
% % warpedim(:, :, 1) = tmp ;
% % tmp(:) = interp2(uc, vc, double(squeeze(im1(:, :, 2))), uc1(:), vc1(:), 'bilinear') ;
% % warpedim(:, :, 2) = tmp ;
% % tmp(:) = interp2(uc, vc, double(squeeze(im1(:, :, 3))), uc1(:), vc1(:), 'bilinear') ;
% % warpedim(:, :, 3) = tmp ;
% 
% for i = 1:d
%     tmp(:) = interp2(uc, vc, double(squeeze(im1(:, :, i))), uc1(:), vc1(:), 'bilinear') ;
%     warpedim(:, :, i) = tmp ;
% end

%% 自己写的插值函数
 % Image size
%  I = im1;
%   sx = size(I, 2); 
%   sy = size(I, 1); 
% 
%   % Image size w/ padding
%   spx = sx + 2;
%   spy = sy + 2;
%   
%   
%   
%     % Warped image coordinates
%     [X, Y] = meshgrid(1:sx, 1:sy);
%     XI = reshape(X + u, 1, sx * sy);
%     YI = reshape(Y + v, 1, sx * sy);
%     
%     % Bound coordinates to valid region
%     XI = max(1, min(sx - 1E-6, XI));
%     YI = max(1, min(sy - 1E-6, YI));
%     
%     % Perform linear interpolation (faster than interp2)
%     fXI = floor(XI);
%     cXI = ceil(XI);
%     fYI = floor(YI);
%     cYI = ceil(YI);
%     
%     alpha_x = XI - fXI;
%     alpha_y = YI - fYI;
%     
%     O = (1 - alpha_x) .* (1 - alpha_y) .* I(fYI + sy * (fXI - 1)) + ...
%         alpha_x .* (1 - alpha_y) .* I(fYI + sy * (cXI - 1)) + ...
%         (1 - alpha_x) .* alpha_y .* I(cYI + sy * (fXI - 1)) + ...
%         alpha_x .* alpha_y .* I(cYI + sy * (cXI - 1));
%   
% 
%   
%   warpedim = reshape(O, sy, sx);
%% for resolutionProcess_sand
[h w d] = size(im1) ;

[uc vc] = meshgrid( 1:w, 1:h ) ;

uc1 = uc + u ;
vc1 = vc + v ;

warpedim = zeros( size(im1) ) ;
tmp = zeros(h, w) ;

tmp(:) = interp2(uc, vc, double(squeeze(im1(:, :, 1))), uc1(:), vc1(:), 'bilinear') ;
warpedim(:, :, 1) = tmp ;
tmp(:) = interp2(uc, vc, double(squeeze(im1(:, :, 2))), uc1(:), vc1(:), 'bilinear') ;
warpedim(:, :, 2) = tmp ;
tmp(:) = interp2(uc, vc, double(squeeze(im1(:, :, 3))), uc1(:), vc1(:), 'bilinear') ;
warpedim(:, :, 3) = tmp ;