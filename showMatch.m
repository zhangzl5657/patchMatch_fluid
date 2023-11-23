function [count]=showMatch( im1,im2,imgPatchCoord_X,imgPatchCoord_Y,pz)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

%% Create a new image showing the two images side by side.
rows1 = size(im1,1);
rows2 = size(im2,1);
if (rows1 < rows2)
     im1(rows2,1) = 0;
else
     im2(rows1,1) = 0;
end
% Now append both images side-by-side.
im3 = [im1 im2];
%% Show a figure with lines joining the accepted matches.
figure('Position', [100 100 size(im3,2) size(im3,1)]);
colormap('gray');
imagesc(im3);
hold on;
cols1 = size(im1,2);
count = 0;
for row = 1:2: size(imgPatchCoord_Y,1)
    for col = 1:3: size(imgPatchCoord_X,2)
        x1 = (col-1)*pz+ceil(pz/2);
        y1 = (row-1)*pz+ceil(pz/2);
        x2 = imgPatchCoord_X(row,col);
        y2 = imgPatchCoord_Y(row,col);
        if ( x2> 0 && y2>0)
            line([x1 x2+cols1],[y1 y2], 'Color', [rand rand rand],'LineWidth',0.75);
            count = count+1;
        end
    end
end
hold off;
end

