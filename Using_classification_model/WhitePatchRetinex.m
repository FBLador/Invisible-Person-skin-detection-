%   Implementing the WHITE PATCH RETINEX

%   Implemented By: ALI SHARIB 
%   Masters in Computer Vision
%   Universitaire de Bourgogne
%   For further inforamtion Contact: ali.sharib2002@gmail.com
%
%

function Image_out=WhitePatchRetinex(Image)
[nrows ncols dim]=size(Image);

for k=1:dim
Image_CH=(Image(:,:,k));
[nrow ncol]=size(Image_CH);
% reshape the image into a vector for sorting
Y = sort(reshape(Image_CH,numel(Image_CH),1));
% find the index correspoding to the cutoff for the top 20 percent
top20 = ceil(0.8*length(Y));
% find the threshold pixel value
threshold1 = Y(top20);
threshold = Y(top20);
%finding min and max values from the sorted one with the percents below and
%above 20%
minValue=Y(1);%instead (1-threshold)
maxValue=Y(round(numel(Image_CH).*(1-0.04)));  %instead of (1-0.04)0.8627 put threshold
%calling the Transform1 function
Image(:,:,k)=Transform1(Image_CH,minValue,maxValue);
%Reshaping the each image channels
% Image_R=Image(:,:,1);
% Image_G=Image(:,:,2);
% Image_B=Image(:,:,3);
% Image_R=reshape(Image_R,nrow,ncol);
% Image_G=reshape(Image_G,nrow,ncol);
% Image_B=reshape(Image_B,nrow,ncol);
end
%plotting them
Image_out=reshape(Image,nrows,ncols,[]);
%figure(6),imshow(Image_out),title('WhitePatchRetinex');




