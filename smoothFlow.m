function [ u,v] = smoothFlow( I1,I2,u,v)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

[height, width, dim] = size(I1);
[u_H,u_W] = size(u);
I1 = double(I1);
I2 = double(I2);

UU = zeros(height,width);
VV =UU;
UU(1:size(u,1),1:size(u,2)) = u;
VV(1:size(v,1),1:size(v,2)) = v;

% interpolate empty values of  UU & VV by using their neighobrs in u & v
if height > u_H && width > u_W
    UU(u_H:height,1:u_W) = repmat(u(u_H,:),height-u_H+1,1);
    VV(u_H:height,1:u_W) = repmat(v(v_H,:),height-u_H+1,1);
    
    UU(:,u_W:width) = repmat(UU(:,u_W),1,width-u_W+1);
    VV(:,u_W:width) = repmat(VV(:,u_W),1,width-u_W+1);
elseif height > u_H
    UU(u_H:height,1:u_W) = repmat(u(u_H,:),height-u_H+1,1);
    VV(u_H:height,1:u_W) = repmat(v(v_H,:),height-u_H+1,1);
elseif width > u_W
    UU(:,u_W:width) = repmat(u(:,u_W),1,width-u_W+1);
    VV(:,u_W:width) = repmat(v(:,u_W),1,width-v_W+1);
end

% [u,v]=optic_flow_optimization(I1,I2,UU,VV);
% [u,v]=optic_flow_optimization_sand(I1,I2,UU,VV);
[u,v]=optic_flow_optimization_brox(I1,I2,UU,VV);
    
end

