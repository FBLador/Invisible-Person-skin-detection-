% Program using imageDatastore
clear;
close all;

% Directory with sub directories:
DatasetPath = fullfile('C:','Users','mangi','Documents','Bicocca Informatica','3 anno','Elaborazione delle Immagini','Esame 2022 mio','Small_Dataset');
imds = imageDatastore(DatasetPath, 'IncludeSubfolders',true,'LabelSource','foldernames');

% Number of images
num_images = numel(imds.Files)/2;
% Initialize 4 dimensional arrays with fixed dimension
original_images = zeros(num_images,300,300,3);
gt_images = zeros(num_images,300,300);

% Test to read single image
test = imread(imds.Files{1}) > 0.1; % Make it boolean
test = test(:,:,1); % Make it only one channel
imshow(test);


% Cicli per tentare di salvare immagini in array e solo dopo estrarre skin
% pixels. In realtà forse è meglio trovare skin pixel all'interno del ciclo e
% salvare questi valori in array, mentre è inutile stare a fare array di
% immagini
%%
for i = 1:num_images
    im = imread(imds.Files{i}) > 0.1; % Boolean image
    im = im(:,:,1);
    gt_images(i,:,:) = im; % Try to save image in the array
end

for i = 1+num_images:2*num_images
    im = im2double(imread(imds.Files{i}));
    original_images(i-num_images,:,:,:) = im;
end

