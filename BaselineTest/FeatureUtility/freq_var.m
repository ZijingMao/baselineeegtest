function [ FV ] = freq_var( pxx,f  )

fv1=sum(pxx.*(f.*f));%/(sum(pxx))
fv2=((sum(pxx.*(f)))^2)/(sum(pxx));
fv3=(sum(pxx));

FV=(fv1-fv2)/fv3;
end

