
function RGB_Out=ModifiedWhitePatch(RGB_In)

[m n dim]=size(RGB_In);
RGB_Out=zeros(size(RGB_In));
R=mean2(RGB_In(:,:,1));
G=mean2(RGB_In(:,:,2));
B=mean2(RGB_In(:,:,3));
S=220;                   %value equal to the threshold applied
Red=RGB_In(:,:,1);
R1=double(max(Red(:)));
Green=RGB_In(:,:,2);
G1=double(max(Green(:)));
Blue=RGB_In(:,:,3);
B1=double(max(Blue(:)));
 %avg=sum(RGB_In(i,j,1)+RGB_In(i,j,2)+RGB_In(i,j,3))./3;
 if R1>220
     KR=S./R;
     RGB_Out(:,:,1)=KR*RGB_In(:,:,1);
 end
 if G1>220
 KG=S./G;
 RGB_Out(:,:,2)=KR*RGB_In(:,:,2);
 end
 if B1>=220
 KB=S./B;
 RGB_Out(:,:,3)=KB*RGB_In(:,:,3);
 else
 end
 
 
 RGB_Out=uint8(RGB_Out);
end
    
