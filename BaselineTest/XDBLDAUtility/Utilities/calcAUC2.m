function Az = calcAUC2(tp, fp)

 dp = norminv(tp) - norminv(fp);
 Az = 0.5*(1+erf(dp/2));

