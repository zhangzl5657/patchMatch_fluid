function [ I,Iref ] = loadImage(pairN,dataDir)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
%% smoke
% imFiles = dir(sprintf('%s\\pair%04d*.jpg',dataDir,pairN));
% 
% Iref    = im2double(imread(fullfile(dataDir,imFiles(1).name)));
% I       = im2double(imread(fullfile(dataDir,imFiles(2).name)));


% im1 = sprintf('%s\\seacloud\\seacloud%d.jpg',dataDir,pairN);
% im2 = sprintf('%s\\seacloud\\seacloud%d.jpg',dataDir,pairN+1);

% im1 = sprintf('%s\\satellite\\sateImage%d.jpg',dataDir,pairN);
% im2 = sprintf('%s\\satellite\\sateImage%d.jpg',dataDir,pairN+1);
% Iref    = im2double(imread(im1));
% I = im2double(imread(im2));
%% rubber whale
% imFiles = dir(sprintf('%s\\frame%d*.png',dataDir,pairN));
% 
% Iref    = im2double(imread(fullfile(dataDir,imFiles(1).name)));
% I       = im2double(imread(fullfile(dataDir,imFiles(2).name)));


%% cloud
% imFiles = dir(sprintf('%s\\cloud%d*.png',dataDir,pairN));
% 
% Iref    = im2double(imread(fullfile(dataDir,imFiles(1).name)));
% I       = im2double(imread(fullfile(dataDir,imFiles(2).name)));
%% sea of clouds
% imFiles = dir(sprintf('%s\\seacloud%d*.jpg',dataDir,pairN));
% 
% Iref    = im2double(imread(fullfile(dataDir,imFiles(1).name)));
% I       = im2double(imread(fullfile(dataDir,imFiles(2).name)));

%% sateImage
% imFiles = dir(sprintf('%s\\sateImage%d*.jpg',dataDir,pairN));
% 
% Iref    = im2double(imread(fullfile(dataDir,imFiles(1).name)));
% I       = im2double(imread(fullfile(dataDir,imFiles(2).name)));

%% smoke32
% imFiles = dir(sprintf('%s\\photo%d*.jpg',dataDir,pairN));
% 
% Iref    = im2double(imread(fullfile(dataDir,imFiles(1).name)));
% I       = im2double(imread(fullfile(dataDir,imFiles(2).name)));
%%
% imFiles = dir(sprintf('%s\\photo%d*.jpg',dataDir,pairN));
% 
% Iref    = im2double(imread(fullfile(dataDir,imFiles(1).name)));
% I       = im2double(imread(fullfile(dataDir,imFiles(2).name)));
%% genSmoke32.jpg--genSmoke42.jpg
% imFiles = dir(sprintf('%s\\genSmoke%d*.jpg',dataDir,pairN));
% 
% Iref    = im2double(imread(fullfile(dataDir,imFiles(1).name)));
% I       = im2double(imread(fullfile(dataDir,imFiles(2).name)));

%% nibote07,09
% imFiles = dir(sprintf('%s\\nibote%d*.jpg',dataDir,pairN));
% 
% Iref    = im2double(imread(fullfile(dataDir,imFiles(1).name)));
% I       = im2double(imread(fullfile(dataDir,imFiles(2).name)));

%% seav01-seav02
% imFiles = dir(sprintf('%s\\seav%d*.jpg',dataDir,pairN));
% 
% Iref    = im2double(imread(fullfile(dataDir,imFiles(1).name)));
% I       = im2double(imread(fullfile(dataDir,imFiles(2).name)));

%% cloudv01-cloud02
% imFiles = dir(sprintf('%s\\cloudv%d*.jpg',dataDir,pairN));
% 
% Iref    = im2double(imread(fullfile(dataDir,imFiles(1).name)));
% I       = im2double(imread(fullfile(dataDir,imFiles(2).name)));

%% hzcloudv03-hzcloud04
% imFiles = dir(sprintf('%s\\hzcloudv%d*.jpg',dataDir,pairN));
% 
% Iref    = im2double(imread(fullfile(dataDir,imFiles(1).name)));
% I       = im2double(imread(fullfile(dataDir,imFiles(2).name)));

%% timg01-timg02
imFiles = dir(sprintf('%s\\timg%d*.jpg',dataDir,pairN));

Iref    = im2double(imread(fullfile(dataDir,imFiles(1).name)));
I       = im2double(imread(fullfile(dataDir,imFiles(2).name)));

%% frame10
% imFiles = dir(sprintf('%s\\frame%d*.png',dataDir,pairN));
% 
% Iref    = im2double(imread(fullfile(dataDir,imFiles(1).name)));
% I       = im2double(imread(fullfile(dataDir,imFiles(2).name)));
end

