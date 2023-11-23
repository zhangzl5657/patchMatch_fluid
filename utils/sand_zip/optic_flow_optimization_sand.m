function [u, v] = optic_flow_optimization_sand(img1, img2,init_u,init_v)

% Author: zili zhang
% optimize the initial optical flow with warping theory
% init_u, init_v: the given initial velocity 

%%  for resolutionProcess_brox
    %alpha = 10.0 ; % Global smoothness variable.
    %gamma = 15.0 ; % Global weight for derivatives.
%% for resolutionProcess_sand
    alpha_global = 10.0 ;
    alpha_local = 30.0 ;
%%
    [ht, wt, dt] = size( img1 ) ;

    oI1 = im2uint8(img1);
    oI2 = im2uint8(img2);
    wI2 = im2uint8(( mywarp_rgb( double( img2 ), init_u, init_v ) ) );
    rgbI2 = oI2 ; % for resolutionProcess_sand
    u = init_u;
    v = init_v;
    
%% 将rgb图转换成灰度图
    if size(img1,3)>1
        I1 = rgb2gray(img1) ;
    end
    if size(oI2,3)>1
        I2 = rgb2gray(oI2) ;
    end
    

	%% Computing derivatives.
	[Ikx Iky] = imgGrad( I2 ) ;
	[Ikx2 Iky2] = imgGrad( I1 ) ;
	Ikz = double(I2) - double(I1) ;
	Ixz = double(Ikx) - double(Ikx2) ;
	Iyz = double(Iky) - double(Iky2) ;
	%% optimization
	% Calling the processing for a particular resolution.
	% Last two arguments are the outer and inner iterations, respectively.
	% 1.8 is the omega value for the SOR iteration.
    
    %% for resolutionProcess_brox
	% [du, dv] = resolutionProcess_brox( Ikz, Ikx, Iky, Ixz, Iyz, alpha, gamma, 1.8, u, v, 2, 500 ) ;
    
    %% for resolutionProcess_sand
%     num_channels = 5 ;
%     
%     I1 = channels_new( oI1 ) ;
%  	I2 = channels_new( wI2 ) ;
% 
% 	[Ikx Iky] = imgGrad( I2 ) ;
% 	Ikz = I2 - I1 ;


% 
%  load genSmoke.mat;
%     tempAlpha = E;

%   alphaImg = alpha_local * tempAlpha + alpha_global * ones( ht, wt );
    
 	alphaImg = alpha_local * getalphaImg( oI1 ) + alpha_global * ones( ht, wt );

	[du, dv] = resolutionProcess_sand( Ikz, Ikx, Iky, alphaImg, 1.9, u, v, 3, 500 ) ;
    
	% Adding up the optical flow.
	u = u + du ;
	v = v + dv ;

    figure; quiver( u+du, v+dv ) ;


	% Displaying relevant figures.
% 	figure(2); 
% 	subplot(3, 3, 1); imshow(im1_hr) ;
% 	subplot(3, 3, 2); imshow(rgb2gray(im2_hr)) ;
% 	subplot(3, 3, 3); imshow(rgb2gray(im2_orig)) ;
% 	subplot(3, 3, 4); imshow(uint8(double(im1_hr)-double(im2_hr))) ;
% 	subplot(3, 3, 5); imshow(uint8(double(im1_hr)-double(im2_orig))) ;
% 	subplot(3, 3, 6); imshow(uint8(double(im2_hr)-double(im2_orig))) ;
% 	subplot(3, 3, 7); imagesc(u) ;
% 	subplot(3, 3, 8); imagesc(v) ;
% 	subplot(3, 3, 9); imagesc(sqrt(u.^2 + v.^2)) ;
	% pause;
end


