%% Setup
clear;
close all;

% load modello di classificazione
load ../models/FineTree_YCbCr.mat
Mdl = FineTree.ClassificationTree;

% inserire il nome del video di input
vid = vision.VideoFileReader('video.mp4');
% nome del video in output
vidWriter = VideoWriter('video_predicted.avi');
open(vidWriter);

%% Loop
firstFrame = im2double(step(vid));
% filtro gaussiano con deviazione standard = 1 per rimuovere rumore
firstFrame = imgaussfilt(firstFrame, 1);

while ~isDone(vid)
    vidFrame = im2double(step(vid));

    % filtro gaussiano con deviazione standard = 1 per rimuovere rumore
    % dal frame del video
    vidFrame = imgaussfilt(vidFrame, 1);

    [r,c,ch] = size(vidFrame);
    
    vidFrame_reshaped = rgb2ycbcr(reshape(vidFrame,r*c,ch));

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