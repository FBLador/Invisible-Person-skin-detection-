clc;clear;close;

% modificare i percorsi con i propri
photos = imageDatastore('..\Small_Dataset\Pratheepan_Dataset\FacePhoto');
gts = imageDatastore('..\Small_Dataset\Ground_Truth\GroundT_FacePhoto');

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