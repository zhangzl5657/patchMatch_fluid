function [ u,v ] = solveEL ( I1,I2,u,v)
%UNTITLED Summary of this function goes here
% 求解Euler-Lagrange方程 
%   Detailed explanation goes here

% 根据u，v插值获得I(x+u,y+v)
[height, width, dim] = size(I2);
[x,y] = meshgrid(1:width,1:height);
UU = zeros(height,width);
VV =UU;
UU(1:size(u,1),1:size(u,2)) = u;
VV(1:size(v,1),1:size(v,2)) = v;
newX = x + UU;
newY = y + VV;
newX(newX>width) = width;
newX(newX<1) = 1;
newY(newY>height) = height;
newY(newY<1) = 1;
warpI2 = interp2(x,y,I2,newX,newY,'cubic');

Iz = warpI2-I1;
[Izx,Izy] = gaussDeriv_dir(warpI2);
[ux_pre,uy_pre] = gaussDeriv_dir(UU);
[vx_pre,vy_pre] = gaussDeriv_dir(VV);
 u = (-Iz.*Izx+ux_pre+uy_pre)/2;
 v = (-Iz.*Izy+vx_pre+vy_pre)/2;
end

