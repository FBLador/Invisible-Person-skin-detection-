%% Setup
clear;
close all;

% load modello di classificazione
load ('FineTree_HSV.mat');
Mdl = FineTree.ClassificationTree;

% inserire il nome del video di input
vid = vision.VideoFileReader('video.mp4');
% nome del video in output che verrà creato
vidWriter = VideoWriter('video_predicted.avi');
open(vidWriter);

% filtro gaussiano 3x3 con deviazione standard = 0.5 per rimuovere rumore
Gaus = fspecial('gaussian',3,0.5);

%% Loop
firstFrame = im2double(step(vid));
% filtro gaussiano rimuovere rumore
firstFrame = imfilter(firstFrame, Gaus);

while ~isDone(vid)
    vidFrame = im2double(step(vid));

    % filtro gaussiano per rimuovere rumore
    vidFrame = imfilter(vidFrame, Gaus);

    [r,c,ch] = size(vidFrame);
    
    vidFrame_reshaped = rgb2hsv(reshape(vidFrame,r*c,ch));

    score = predict(Mdl,vidFrame_reshaped);

    binaryMask = reshape(score,r,c) > 0.1;

    binaryMask = PostProcessingBASELINE(binaryMask);

    % moltiplico l'inverso della maschera per la luminosità per
    % annerire i pixel del colore nel range prefissato
    vidFrame(:,:,:) = vidFrame(:,:,:) .* (1 - binaryMask);
    coloredMask = vidFrame;

    % applico la maschera binaria al primo frame
    firstFrameMasked = firstFrame .* binaryMask;
    % somma per ottenere il frame che verrà inserito nel video
    out = coloredMask + firstFrameMasked;

    step(vid);
    writeVideo(vidWriter, out);
end

%% Cleanup
release(vid);
close(vidWriter);
clear;
close all;