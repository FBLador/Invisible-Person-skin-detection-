function out= NormalizeColors(Image)

[nrow ncol dim]=size(Image);
Image(Image(:,:,:)==0)=1;
for i=1:nrow
    for j=1:ncol
        
        Image(i,j,:)=(Image(i,j,:)./(Image(i,j,1)+Image(i,j,2)+Image(i,j,3)));
    end
end
out=Image;
%figure(4),imshow(mat2gray(Image));
end
