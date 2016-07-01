function [ CGF ] = CGF_calc( pxx,f )
 
CGF=(sum(pxx.*f))/(sum(pxx));

end

