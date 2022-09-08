% Writing the fucntion for Automatic Color Equalization
% Parameters:
%           x=output after applying the ACE algorithm
%           Input= image whose ACE is to be done is passed as input
%           parameter

function [x]=ACE(Input)
    [R C M] = size(Input);
    Input1 = double(Input);
    Rcr = double(zeros(R,C));
    Rcg = double(zeros(R,C));
    Rcb = double(zeros(R,C));
    for i=1:1:R
 %    
        for j=1:1:C
            Icr = Input1(i,j,1);
            Icg = Input1(i,j,2);
            Icb = Input1(i,j,3);
            temp_r =0;
            temp_g =0;
            temp_b =0;
                      
            for k=1:1:R
                for l=1:1:C
                
                    if(~((j==l)))
                        out_r =75*(Icr - Input1(k,l,1));
                        out_g =75*(Icg - Input1(k,l,2));
                        out_b =75*(Icb - Input1(k,l,3));
                    
                        distance = sqrt(((k-i)*(k-i))+((l-j)*(l-j)));
                    
                        out_r = out_r/distance;
                        out_g = out_g/distance;
                        out_b = out_b/distance;
                    
                        temp_r = temp_r + out_r;
                        temp_g = temp_g + out_g;
                        temp_b = temp_b + out_b;
                                               
                    end
                  end
            end
            
            Rcr(i,j)=temp_r;
            Rcg(i,j)=temp_g;
            Rcb(i,j)=temp_b;
        end
    end
    
  
    
    
    mr=min(min(Rcr));
    mg=min(min((Rcg)));
    mb=min(min((Rcb)));
    Mr=max(max(Rcr));
    Mg=max(max(Rcg));
    Mb=max(max(Rcb));
    
    Scr=255/(Mr-mr);                     %[(mc,0),(Mc,255)]
    Scg=255/(Mg-mg);                     %[(mc,0),(Mc,255)]
    Scb=255/(Mb-mb);                     %[(mc,0),(Mc,255)]
    
       
    Out_r(:,:)=round(Scr*(Rcr(:,:,1)-mr));
    Out_g(:,:)=round(Scr*(Rcg(:,:,1)-mg));
    Out_b(:,:)=round(Scr*(Rcb(:,:,1)-mb));
            
    output=double(zeros(R,C,M));
    
    output(:,:,1)=Out_r;
    output(:,:,2)=Out_g;
    output(:,:,3)=Out_b;
  

    x=output;

end