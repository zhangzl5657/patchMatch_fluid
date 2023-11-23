uv = cat(3,pixelCorrCoord_Y,pixelCorrCoord_X);
opts.beta    = [1 1 10];
opts.print   = true;
opts.method  = 'l1';
H = fspecial('gaussian',[5 5], 2);
% Setup mu
mu           = 1;

% Main routine
out1 = deconvtv(uv, H, mu, opts);

pixelCorrCoord_Y = out1.f(:,:,1);
pixelCorrCoord_X = out1.f(:,:,2);