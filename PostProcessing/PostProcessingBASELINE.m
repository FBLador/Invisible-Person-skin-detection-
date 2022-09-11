function NBW = PostProcessingBASELINE(NBW)

doFill = 1; % Flag for closing operator (True by default)

% IMFILL
if doFill
    filledBW = imfill(NBW,'holes');   % Closing holes
else
    filledBW = ~(bwareaopen(~NBW,2)); % Closing holes smaller than 3 px
end

radius = 6; % Structuring element radius
% IMERODE
se3 = strel('disk',radius,4);
erodedBW= imerode(filledBW,se3);   % Erosion on filled NBW
% AREAOPEN
erodedBW = bwareaopen(erodedBW, 2*3*radius);    % Removing areas smaller than a structurig element
% IMDILATE
se4 = strel('disk',radius,4);
dilatedBW = imdilate(erodedBW,se4); % Dilating remaining areas
% IMMULTIPLY
multiplyBW = immultiply(dilatedBW,NBW);  % Restoring original holes in the remaining areas

NBW = multiplyBW; % Final result

