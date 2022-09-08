function RGB_Out=WhitePatch(RGB_In)

[m n dim]=size(RGB_In);
RGB_Out=zeros(size(RGB_In));
R=RGB_In(:,:,1);
R1=double(max(R(:)));
G=RGB_In(:,:,2);
G1=double(max(G(:)));
B=RGB_In(:,:,3);
B1=double(max(B(:)));
 S=255; 
 KR=S./R1;
 KG=S./G1;
 KB=S./B1;

% for i=1:1:m
%      for j=1:1:n
 
 RGB_Out(:,:,1)=KR*RGB_In(:,:,1);
 RGB_Out(:,:,2)=KG*RGB_In(:,:,2);
 RGB_Out(:,:,3)=KB*RGB_In(:,:,3);
 RGB_Out=uint8(RGB_Out);
%      end
% end
end