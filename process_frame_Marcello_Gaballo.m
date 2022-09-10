function process_frame(frame,first_frame)

load fine_tree.mat;

Md1= fine_tree.ClassificationTree;

frame_double= im2double(frame);

first_frame_double= im2double(first_frame);

[r,c,ch]= size(frame_double);

frame_reshaped = reshape(frame_double,r*c,ch);

score= predict(Md1,frame_reshaped);

binary_mask= reshape(score,r,c) > 0.1;

binary_mask2= 1-binary_mask;

frame1= first_frame_double .*im2double(binary_mask);

frame2= frame_double .* im2double(binary_mask2);

imshow(frame1+frame2);

