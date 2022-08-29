%% Setup
clear;
close all;
myCam = imaq.VideoDevice('winvideo');
myCam.VideoFormat = 'MJPG_1280x720';
vidPlayer = vision.DeployableVideoPlayer;

%% Loop
firstFrame = im2double(step(myCam));
s = strel('square', 7); % elemento strutturante per morfologia matematica

load trainedModel.mat
kNNMdl = trainedModel.ClassificationKNN;

for idx = 1:50
    vidFrame = im2double(step(myCam));
    [r,c,ch] = size(vidFrame);
    
    vidFrame_reshaped = reshape(vidFrame,r*c,ch);
    score = predict(kNNMdl,vidFrame_reshaped);

    % Ristrutturiamo il vettore delle etichette in una immagine
    binaryMask = reshape(score,r,c) > 0.1;

    % Applico morfologia matematica e sfocatura per pulire la maschera
    binaryMask = medfilt2(binaryMask, [13 13]);
    binaryMask = imdilate(binaryMask, s); % dilate delle parti bianche della maschera
    % Moltiplico l'inverso della maschera per la luminosità, così da
    % annerire i pixel del colore nel range prefissato
    vidFrame(:,:,:) = vidFrame(:,:,:) .* (1 -binaryMask);
    coloredMask = vidFrame;
    % Applico la maschera binaria al primo frame, così da annerire tutte le
    % regioni che non mi interessano
    firstFrameMasked = firstFrame .* binaryMask;
    % Sommo le due maschere che insieme completeranno l'immagine
    out = coloredMask + firstFrameMasked;
    step(vidPlayer, out);
end

%% Cleanup
release(vidPlayer);
clear;
close all;
