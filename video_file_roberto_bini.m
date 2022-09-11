%% Setup
clear;
close all;

i = 0;

% mettere il nome del video
vid = vision.VideoFileReader('video.mp4');
%vidPlayer = vision.DeployableVideoPlayer;
vidWriter = VideoWriter('video_predicted.avi');

open(vidWriter);

%% Loop
firstFrame = im2double(step(vid));
s = strel('square', 7); % elemento strutturante per morfologia matematica

load ../models/QuadraticDiscriminant.mat
kNNMdl = QuadraticDiscriminant.ClassificationDiscriminant;

while ~isDone(vid)
    vidFrame = im2double(step(vid));

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
    step(vid);
    writeVideo(vidWriter, out);
    i = i+1;
    disp(i);
end

%% Cleanup
release(vid);
%release(vidPlayer);
close(vidWriter);
clear;
close all;