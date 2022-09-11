%% Setup
clear;
close all;

% Load classification model
load FineTree_HSV.mat;
Mdl = FineTree.ClassificationTree;

% Open Camera
myCam = imaq.VideoDevice('winvideo');
myCam.VideoFormat = 'MJPG_1280x720';
vidPlayer = vision.DeployableVideoPlayer;

%% Loop
firstFrame = im2double(step(myCam));
figure, imshow(firstFrame);

for idx = 1:300
    vidFrame = im2double(step(myCam));
    figure, imshow(vidFrame);
    vidFrameProcess = rgb2hsv(vidFrame);
    [r,c,ch] = size(vidFrameProcess);
    
    vidFrame_reshaped = reshape(vidFrameProcess,r*c,ch);
    score = predict(Mdl,vidFrame_reshaped);

    % Ristrutturiamo il vettore delle etichette in una immagine
    binaryMask = reshape(score,r,c) > 0.1;
    figure, imshow(binaryMask);

    % Moltiplico l'inverso della maschera per la luminosità, così da
    % annerire i pixel del colore nel range prefissato
    vidFrame(:,:,:) = vidFrame(:,:,:) .* (1 -binaryMask);
    coloredMask = vidFrame;
    figure, imshow(coloredMask);
    % Applico la maschera binaria al primo frame, così da annerire tutte le
    % regioni che non mi interessano
    firstFrameMasked = firstFrame .* binaryMask;
    figure, imshow(firstFrameMasked);
    % Sommo le due maschere che insieme completeranno l'immagine
    out = coloredMask + firstFrameMasked;
    figure, imshow(out);
    step(vidPlayer, out);
end

%% Cleanup
release(vidPlayer);
clear;
close all;
