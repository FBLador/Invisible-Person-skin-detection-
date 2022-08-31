clear;
close all;

myFolder = fullfile('C:','Users','mangi','Documents','Bicocca Informatica','3 anno','Elaborazione delle Immagini','Esame 2022 mio','Small_Dataset', 'Ground_Truth');
filePattern = fullfile(myFolder, '*.png');
pngFiles = dir(filePattern);
for k = 1:length(pngFiles)
    baseFileName = pngFiles(k).name;
    fullFileName = fullfile(myFolder, baseFileName);
    fprintf(1, 'Now reading %s\n', fullFileName);
    imageArray = imread(fullFileName);
    imshow(imageArray);  % Display image.
    drawnow; % Force display to update immediately.
end