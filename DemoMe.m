% im1 = imread('smoke1.jpg');
% im2 = imread('smoke2.jpg');

% im1 = imread('seacloud01.jpg');
% im2 = imread('seacloud02.jpg');

% im1 = imread('nibote04.jpg');
% im2 = imread('nibote06.jpg');
% 
% im1 = imread('sateImage01.jpg');
% im2 = imread('sateImage02.jpg');

% im1 = imread('genSmoke62.jpg');
% im2 = imread('genSmoke63.jpg');

% im1 = imread('hzcloudv05.jpg');
% im2 = imread('hzcloudv06.jpg');

im1 = imread('timg01.jpg');
im2 = imread('timg02.jpg');
method = 'hs';
% method = 'classic+nl';
uvo = estimate_flow_interface(im1, im2, method);