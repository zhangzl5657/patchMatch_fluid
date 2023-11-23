function [rect,varargout] = findTargetLocation(map,modeType,WH,WHGT)

switch lower(modeType)
    case 'max'
        [val,ind] = max(map(:));
    case 'min'
        [~,ind] = min(map(:));
end
if val>0.8
[y,x] = ind2sub(size(map),ind);
rect = [x-WH(1)/2,y-WH(2)/2,WH];
else
 rect = [1,1,WH];   
end
if nargin>3
    varargout{1} = [x-WHGT(1)/2,y-WHGT(2)/2,WHGT];
end