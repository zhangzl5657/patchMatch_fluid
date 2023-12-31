function [u, v] = optic_flow_optimization_brox(img1, img2,init_u,init_v)

% Author: zili zhang
% optimize the initial optical flow with warping theory
% init_u, init_v: the given initial velocity 


    alpha = 1 ; % Global smoothness variable.
    gamma = 80.0 ; % Global weight for derivatives.
    
    alpha_global = 20.0 ;
    alpha_local = 15.0 ;

    [ht, wt, dt] = size( img1 ) ;

    I1 = im2uint8(img1);
    I2 = im2uint8( mywarp_rgb( double( img2 ), init_u, init_v ) ) ;
    u = init_u;
    v = init_v;
    
%% ��rgbͼת���ɻҶ�ͼ
    if size(img1,3)>1
        I1 = rgb2gray(img1) ;
    end
    if size(img2,3)>1
        I2 = rgb2gray(img2) ;
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
%     
    load timg.mat;
    alphaImg = E;
%     alphaImg = getalphaImg(I1);

%     [htn, wtn, dtn] = size( I1 ) ;
%     alphaImg = alpha_local * getalphaImg( I1 ) + alpha_global * ones( htn, wtn ) ;
	[du, dv] = resolutionProcess_brox( Ikz, Ikx, Iky, Ixz, Iyz, alpha, gamma, 1.8, u, v, 1, 500,alphaImg ) ;
	
	% Adding up the optical flow.
	u = u + du ;
	v = v + dv ;



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


