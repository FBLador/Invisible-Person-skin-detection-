% Program using imageDatastore

clear;
close all;

% Directory with sub directories: 
DatasetPath = fullfile('C:\Users\mangi\Documents\Github\Invisible-Person-skin-detection-\Small_Dataset\Full' );
imds = imageDatastore(DatasetPath, 'IncludeSubfolders',true,'LabelSource','foldernames');

% Number of images
num_images = numel(imds.Files)/2;

% Arrays to store pixel values (later will delete rows not used)
skin_pixels = zeros(250000 * num_images,3);
not_skin_pixels = zeros(250000 * num_images,3);
tot_rows = 0; % useful later to fill the arrays

fprintf('Done with initialization \n');

% im_gt = image ground truth   im_o = image original with colors
for i = 1:num_images
    im_gt = imread(imds.Files{i}) > 0.1; % Ground Truth boolean image
    im_gt = im_gt(:,:,1);
    im_o = im2double(imread(imds.Files{i+num_images})); % Original image
    im_o_R = im_o(:,:,1);
    im_o_G = im_o(:,:,2);
    im_o_B = im_o(:,:,3);

    % Find skin pixels
    skin_im_o_R = im_o_R .* im_gt;
    skin_im_o_G = im_o_G .* im_gt;
    skin_im_o_B = im_o_B .* im_gt;
    skin_im_o = [skin_im_o_R, skin_im_o_G, skin_im_o_B];
    % Reshape image in a 2 dim matrix: each pixel in a row, 3 columns for its RGB values
    skin_im_o_reshaped = reshape(skin_im_o, [], 3);
    
    tot_rows = tot_rows + height(skin_im_o_reshaped); % useful later to fill the array
    
    % for every row (for every pixel):
    for j = 1:height(skin_im_o_reshaped)
        rgb = skin_im_o_reshaped(j, :);
        zero_rgb = [0,0,0];
        if not(rgb == zero_rgb) % if its not black add RGB values to array
            skin_pixels(j + tot_rows,:) = rgb;
        end
    end

    % Find NOT skin pixels in the same way:

    reverse_im_gt = 1 - im_gt;
    % Find not skin pixels
    not_skin_im_o_R = im_o_R .* reverse_im_gt;
    not_skin_im_o_G = im_o_G .* reverse_im_gt;
    not_skin_im_o_B = im_o_B .* reverse_im_gt;
    not_skin_im_o = [not_skin_im_o_R, not_skin_im_o_G, not_skin_im_o_B];
    % Reshape image in a 2 dim matrix: each pixel in a row, 3 columns for its RGB values
    not_skin_im_o_reshaped = reshape(not_skin_im_o, [], 3);

    % for every row (for every pixel):
    for j = 1:height(not_skin_im_o_reshaped)
        rgb = not_skin_im_o_reshaped(j, :);
        zero_rgb = [0,0,0];
        if not(rgb == zero_rgb) % if its not black add RGB values to array
            not_skin_pixels(j + tot_rows,:) = rgb;
        end
    end
    
    fprintf('Done with image %d. \n', i);
end

% Delete rows not used full of zeros
skin_pixels = skin_pixels(any(skin_pixels,2),:);
not_skin_pixels = not_skin_pixels(any(not_skin_pixels,2),:);

% Save results with also labels (1 for skin pixel, 0 for not)
label_skin = ones(height(skin_pixels),1);
label_not_skin = zeros(height(not_skin_pixels),1);

T_skin = table(skin_pixels,label_skin);
T_not_skin = table(not_skin_pixels,label_not_skin);
T_skin.Properties.VariableNames = ["RGB","Label"];
T_not_skin.Properties.VariableNames = ["RGB","Label"];
T = vertcat(T_skin, T_not_skin);
save('T_skin_and_not.mat', 'T');

