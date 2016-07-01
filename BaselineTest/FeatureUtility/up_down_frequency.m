function [ f_don,f_up ] = up_down_frequency( pxx,f,k )

kk=length(pxx);
f_up=[];
ind=1;
ii=k+1;

if k ~= kk
    
    while((ind==1) & (ii<=kk))
                
        if pxx(ii)<=(pxx(k)/2)
            f_up=f(ii);
            ind=0;
        end
        
        if isempty(f_up)
            f_up=f(k);
        end
        
        ii=ii+1;
    end
    
else
    
    f_up=f(k);
    
end


kk=length(pxx);
f_don=[];
ind=1;
ii=k;

if k~=1
    
    while((ind==1) & (ii>1))
        
        ii=ii-1;
        
        if pxx(ii)<=(pxx(k)/2)
            f_don=f(ii);
            ind=0;
        end
        
        if isempty(f_don)
            f_don=f(k);
        end
    end
    
else
    
    f_don=f(k);
    
end

end

