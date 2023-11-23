function [gtRect] = loadTargetLocation(pairN,dataDir)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

rectFile = dir(sprintf('%s\\pair%04d*.txt',dataDir,pairN));

%rect    = round(load(fullfile(dataDir,rectFile(1).name)));
gtRect  = round(load(fullfile(dataDir,rectFile(2).name)));

%根据指定的坐标生成模板
%T = imcrop(Iref,rect);

end

