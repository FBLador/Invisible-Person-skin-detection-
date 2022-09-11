%% Setup
clear;
close all;

% load modello di classificazione
load ('FineTree_HSV.mat');
Mdl = FineTree.ClassificationTree;

myCam = imaq.VideoDevice('winvideo');
% inserire il formato del proprio dispositivo di acquisizione
myCam.VideoFormat = 'MJPG_848x480';
vidPlayer = vision.DeployableVideoPlayer;

% filtro gaussiano 3x3 con deviazione standard = 0.5 per rimuovere rumore
Gaus = fspecial('gaussian',3,0.5);

%% Loop
firstFrame = im2double(step(myCam));
% filtro gaussiano per rimuovere rumore
firstFrame = imfilter(firstFrame, Gaus);

for idx = 1:1000
    vidFrame = im2double(step(myCam));

    % filtro gaussiano per rimuovere rumore
    vidFrame = imfilter(vidFrame, Gaus);

    vidFrame = GrayWorld(vidFrame);

    [r,c,ch] = size(vidFrame);
    
    vidFrame_reshaped = rgb2hsv(reshape(vidFrame,r*c,ch));

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