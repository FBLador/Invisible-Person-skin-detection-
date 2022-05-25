%% Setup
clear;
close all;
myCam = imaq.VideoDevice('winvideo');
myCam.VideoFormat = 'MJPG_640x480';
vidPlayer = vision.DeployableVideoPlayer;

%% Loop
firstFrame = im2double(step(myCam));
s = strel('square', 7); % elemento strutturante per morfologia matematica
for idx = 1:500
    vidFrame = rgb2hsv(im2double(step(myCam)));
    % Creo maschere con i pixel=1 se nel range, pixel=0 altrimenti
    binaryMaskH = (cos(vidFrame(:,:,1)) > cos(0.48) & cos(vidFrame(:,:,1)) < cos(0.73));
    binaryMaskH = (sin(vidFrame(:,:,1)) > sin(0.48) & sin(vidFrame(:,:,1)) < sin(0.73)); % Hue più o meno blu (TODO: usare sen e cos)
    binaryMaskS = (vidFrame(:,:,2) > 0.5); % Soglia di saturazione
    % Applico morfologia matematica e sfocatura per pulire la maschera
    binaryMask = medfilt2((binaryMaskH&binaryMaskS), [13 13]);
    binaryMask = imdilate(binaryMask, s); % dilate delle parti bianche della maschera
    % Moltiplico l'inverso della maschera per la luminosità, così da
    % annerire i pixel del colore nel range prefissato
    vidFrame(:,:,3) = vidFrame(:,:,3) .* (1 -binaryMask);
    coloredMask = hsv2rgb(vidFrame);
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
