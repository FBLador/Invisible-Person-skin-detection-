function NBW = PostProcessingOM(BW,a1,a2,b1,b2,c1)
%a1,a2,b1,b2,c1  are the parameters, see the paper
%BW stores the skin mask
%The optimal EM parameters (a1,a2,b1,b2,c1) learned for SA3 and SegNet using all the datasets are: 
% (0.3, 0.06, 16, 48, 0.55) and (0.3, 0.06, 10, 40, 0.25) respectively.

       
    class = 'E';% Default class
     
    % Morphological operators variables initialization
    doFill = 1; % Flag for closing operator (True by default) 
    
    %% Pattern classification
    
    % TH1 computation
    fBW = imfill(BW,'holes');   % Closing foles in BW
    totalP = numel(BW);         % Total surface of BW
    whiteP = sum(sum(fBW==1));  % Skin surface of fBW
    TH1 = whiteP / totalP;      % TH1 computation
    
    % TH1 check
    if TH1 >= a1
        % Patterns with high percentage of skin
       
        % Heavy erosion
        se = strel('disk', 10, 4);  % Creating structuring element
        eBW= imerode(BW,se);        % Erode that aims to divide in smaller areas
        
        % TH2 computation (number of connected components)
        CC = bwconncomp(eBW);   % Connected components of eBW
        TH2 = CC.NumObjects;    % Number of connected components of eBW
        
        % TH2 check
        if TH2 < b1
            % Person which may have white background
            
            % TH3 computation
            sizeBW = size(BW);  % BW size
            perimeter = 2 * sizeBW(1) + sizeBW(2); % Perimeter ignoring bottom side
            
            % Counting skin pixel on the left, right, top sides of eBW
            frame = sum(sum(eBW(1,:)==1)) + sum(sum(eBW(1:end-1,1)==1)) + sum(sum(eBW(1:end-1,end)==1));
            
            TH3 = frame/perimeter; % TH3 computation
            
            % TH3 check
            if TH3 >= c1
                class = 'A'; % Pattern labeled A
            else
                class = 'B'; % Pattern labeled B
            end
            
        else
            class = 'C'; % Pattern labeled C
        end
        
    elseif TH1 > a2 && TH1 < a1    % a2 < TH1 < a1
        
        % Removing areas smaller than (or equal to) 10px before calculating
        % TH2
        BW2 = bwareaopen(BW, 10);
        
        % Computing TH2 (number of connected components)
        CC2 = bwconncomp(BW2);
        TH2 = CC2.NumObjects;
        
        % TH2 check
        if TH2 > b2
            class = 'D'; % Pattern labeled D
        end
    end
    
    %% Pattern processing
    
    switch (class)
        case 'A'
            % White background is present
                
            % Detect background area (the biggest)
            eBW(1,:) = 1;           % Set first row of eBW to 1
            CC1 = bwconncomp(eBW);  % Counting connected components of eBW
            maxL = max(cellfun(@length,CC1.PixelIdxList)); % Area of the bigger component
                
            % Extracting area where the surfece is maxL
            bgPixelList = CC1.PixelIdxList{1};
            for i = 1:length(CC1.PixelIdxList)
                if length(CC1.PixelIdxList{i}) == maxL
                   bgPixelList = CC1.PixelIdxList{i}; % Background found!
                end
            end
               
            % Copying background component from eBW
            bgArea = zeros(size(BW));
            bgArea(bgPixelList) = 1;
              
            % Heavy dilate of the extracted area to restore the previous erosion
            % effect
            se2 = strel('disk',10,4);
            bgArea = imdilate(bgArea,se2);
                 
            nobgBW = immultiply(BW,~bgArea); % Removing bgArea from BW
              
            NBW = nobgBW; % Image ready for standard processing   
            
        case 'B'
            % Image of a person, requires little processing
            NBW = BW;
            doFill=0;   % No closing in the standard processing.
            
        case 'C'
            % Groups of people
            NBW = BW;
            doFill = 0; % No closing in the standard processing.
            
        case 'D'
            NBW = BW;
            doFill = 0; % No closing in the standard processing.
                           
        case 'E'
            % Default
            % Requires little processing
            NBW = BW;
    end
    
    %% STANDARD PROCESSING

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
    multiplyBW = immultiply(dilatedBW,BW);  % Restoring original holes in the remaining areas
    
    NBW = multiplyBW; % Final result
    
    return
end