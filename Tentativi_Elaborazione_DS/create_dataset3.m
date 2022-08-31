% https://it.mathworks.com/matlabcentral/answers/36975-loading-images-in-a-variable
clear;
close all;

% Directories with images
DatasetPath_gt = fullfile('C:','Users','mangi','Documents','Bicocca Informatica','3 anno','Elaborazione delle Immagini','Esame 2022 mio','Small_Dataset', 'Ground_Truth');
DatasetPath_original = fullfile('C:','Users','mangi','Documents','Bicocca Informatica','3 anno','Elaborazione delle Immagini','Esame 2022 mio','Small_Dataset', 'Pratheepan_Dataset');

% Extension of all images are jpg
ext_img = '*.jpg';
% Load images in "gt" and "o" variables
gt = dir([DatasetPath_gt ext_img]);
o = dir([DatasetPath_original ext_img]);
% number of image files
nfile = max(size(gt)) ;
% loop to read the images, but not save them in an array :(
for i=1:nfile
  my_img_gt(i).img = imread([DatasetPath_gt gt(i).name]);
end
for i=1:nfile
  my_img_o(i).img = imread([DatasetPath_original o(i).name]);
end