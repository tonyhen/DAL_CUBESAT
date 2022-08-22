for j = 1:col
    % Beta Angle
    be(:,j) = acosd(((ts(1,j)^2 + sed(1,j)^2 - et(1,j)^2)/(ts(1,j)*sed(1,j)*2)));
    alpha(:,j) = atand(re/sqrt(abs(sed(:,j))-re^2));
end