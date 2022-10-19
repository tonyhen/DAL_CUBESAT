
for k = 1:col
    if be(1,k) < alpha(1,k) && abs(ts(1,k)) > sqrt(sed(1,k)^2-re^2);
        delta(1,k) = 0;
    else
        delta(1,k) = 1;
    end 
    disp(k)
end

%I = illumination (W m^-2)
%
AU = 149.5988 * 10^9;
for l = 1:col
    I(1,l) = 1371 * 0.707 * delta(1,l) * (sed(1,l)/AU)^2 * sqrt(abs(ts(1,l)));
end
