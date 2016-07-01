function Az = calcAUC(pred, targInds, nonTargInds)

pred(pred < 0) = 0;

ti = length(targInds);
if ti == 0
    ti = 1;
end

nti = length(nonTargInds);
if nti == 0
    nti = 1;
end


 tp = sum(pred(targInds)) / ti;
 fp = sum(pred(nonTargInds)) / nti;
 dp = norminv(tp) - norminv(fp);
 Az = 0.5*(1+erf(dp/2));

