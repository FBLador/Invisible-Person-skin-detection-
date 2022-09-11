%% Setup
clear;
close all;

<<<<<<< HEAD
% Load classification model
load FineTree_HSV.mat;
=======
% load modello di classificazione
load FineTree_YCbCr.mat;
>>>>>>> 271d59f6c1762d236eea4c1d0732693aecfaea54
Mdl = FineTree.ClassificationTree;

myCam = imaq.VideoDevice('winvideo');
% inserire il formato del proprio dispositivo di acquisizione
myCam.VideoFormat = 'MJPG_1280x720';
vidPlayer = vision.DeployableVideoPlayer;

%% Loop
firstFrame = im2double(step(myCam));
% filtro gaussiano con deviazione standard = 1 per rimuovere rumore
firstFrame = imgaussfilt(firstFrame, 1);

for idx = 1:1000
    vidFrame = im2double(step(myCam));
<<<<<<< HEAD
    vidFrameProcess = rgb2hsv(vidFrame);
    [r,c,ch] = size(vidFrameProcess);
    
    vidFrame_reshaped = reshape(vidFrameProcess,r*c,ch);
=======

    % filtro gaussiano con deviazione standard = 1 per rimuovere rumore
    % dal frame del video
    vidFrame = imgaussfilt(vidFrame, 1);

    vidFrame = GrayWorld(vidFrame);

    [r,c,ch] = size(vidFrame);
    
    vidFrame_reshaped = reshape(vidFrame,r*c,ch);

>>>>>>> 271d59f6c1762d236eea4c1d0732693aecfaea54
    score = predict(Mdl,vidFrame_reshaped);

    binaryMask = reshape(score,r,c) > 0.1;

    % moltiplico l'inverso della maschera per la luminosità, così da
    % annerire i pixel del colore nel range prefissato
    vidFrame(:,:,:) = vidFrame(:,:,:) .* (1 -binaryMask);
    coloredMask = vidFrame;

<<<<<<< HEAD
    % Applico la maschera binaria al primo frame, così da annerire tutte le
    % regioni che non mi interessano
    firstFrameMasked = firstFrame .* binaryMask;

    % Sommo le due maschere che insieme completeranno l'immagine
=======
    % applico la maschera binaria al primo frame
    firstFrameMasked = firstFrame .* binaryMask;
    % somma per ottenere il frame che verrà inserito nel video
>>>>>>> 271d59f6c1762d236eea4c1d0732693aecfaea54
    out = coloredMask + firstFrameMasked;

    step(vidPlayer, out);
end

%% Cleanup
release(vidPlayer);
release(myCam);
clear;
close all;