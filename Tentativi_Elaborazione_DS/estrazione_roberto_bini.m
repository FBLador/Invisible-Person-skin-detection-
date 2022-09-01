clc;clear;close;

photos = imageDatastore('E:\elaborazione delle immagini\progetto\Invisible-Person-skin-detection--main\Small_Dataset\dataset\FacePhoto');
gts = imageDatastore('E:\elaborazione delle immagini\progetto\Invisible-Person-skin-detection--main\Small_Dataset\Ground_Truth\GroundT_FacePhoto');

% usare le gts come maschere per avere due variabili, una con le parti di
% pelle delle photos e una senza le parti di pelle delle photos.
% poi allenare un nuovo modello con skin e noSkin

skins = {};
noSkins = {};

for i = 1:numel(photos.Files)
    
    photo = readimage(photos, 1);
    gt = readimage(gts, 1)>0;
    
    skin = bsxfun(@times, photo, cast(gt, 'like', photo));
    noskin = photo - skin;
    
    skins(i) = {skin};
    noSkins(i) = {noskin};

end