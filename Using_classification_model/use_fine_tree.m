%% Setup
clear;
close all;

% load modello di classificazione
load ../models/FineTree_YCbCr.mat;
Mdl = FineTree.ClassificationTree;

myCam = imaq.VideoDevice('winvideo');
% inserire il formato del proprio dispositivo di acquisizione
myCam.VideoFormat = 'RGB24_960x720';
vidPlayer = vision.DeployableVideoPlayer;

%% Loop
firstFrame = im2double(step(myCam));
% filtro gaussiano con deviazione standard = 1 per rimuovere rumore
firstFrame = imgaussfilt(firstFrame, 1);

for idx = 1:1000
    vidFrame = im2double(step(myCam));

    % filtro gaussiano con deviazione standard = 1 per rimuovere rumore
    % dal frame del video
    vidFrame = imgaussfilt(vidFrame, 1);

    vidFrame = GrayWorld(vidFrame);

    [r,c,ch] = size(vidFrame);
    
    vidFrame_reshaped = rgb2ycbcr(reshape(vidFrame,r*c,ch));

    score = predict(Mdl,vidFrame_reshaped);

    binaryMask = reshape(score,r,c) > 0.1;

    binaryMask = PostProcessingBASELINE(binaryMask);

    % moltiplico l'inverso della maschera per la luminosità, così da
    % annerire i pixel del colore nel range prefissato
    vidFrame(:,:,:) = vidFrame(:,:,:) .* (1 -binaryMask);
    coloredMask = vidFrame;

    % applico la maschera binaria al primo frame
    firstFrameMasked = firstFrame .* binaryMask;
    % somma per ottenere il frame che verrà inserito nel video
    out = coloredMask + firstFrameMasked;

    step(vidPlayer, out);
end

%% Cleanup
release(vidPlayer);
release(myCam);
clear;
close all;