function [I,Iref] = adjustImageSize(I,Iref,pz)

%修改模板大小
% szT = size(T);
% mt = mod(szT(1:2),pz);
% if(any(mt))
%     T = T(1:end-mt(1),1:end-mt(2), :);
%     rect(3:4) = rect(3:4)-mt;
% end

%修改图像大小
szI = size(I);
mi = mod(szI(1:2),pz);
if(any(mi))
    I = I(1:end-mi(1),1:end-mi(2), :);
    Iref = Iref(1:end-mi(1),1:end-mi(2), :);    
end