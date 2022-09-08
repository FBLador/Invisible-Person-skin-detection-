%GRAYWORLD ALGORITHM APPLIED

%   Implemented By: ALI SHARIB 
%   Masters in Computer Vision
%   Universitaire de Bourgogne
%   For further inforamtion Contact: ali.sharib2002@gmail.com
%

function OutputImage= GrayWorld(Image)

[nrow ncol dim]=size(Image);
% InputImage=Image(nrow,ncol);
a=sum(sum(Image(:,:)));
Estill=a;
OutputImage=zeros(size(Image));
for k=1:dim
OutputImage(:,:,k)=Image(:,:,k)./a;
% reshape the image into a vector for sorting
Y = sort(reshape(OutputImage(:,:,k),numel(OutputImage(:,:,k)),1));
% find the index correspoding to the cutoff for the top 20 percent
top20 = ceil(0.02*length(Y));
% find the threshold pixel value
threshold = Y(top20);
%finding min and max values from the sorted one with the percents below and
%above 20%
%minValue=Y(round(3*numel(OutputImage)*threshold));%instead (1-threshold)
pWhite=0.01;
maxValue=Y(round((nrow*ncol).*(1-pWhite)));  
%
OutputImage(:,:,k)=OutputImage(:,:,k)./maxValue;
end
%OutputImage=reshape(OutputImage,nrow,ncol);
%figure(7),imshow((OutputImage)),title('GrayWorld');




