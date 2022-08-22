% Converts the ECEF frame to ECI and returns the sun position in eci
% frame 

% sat_eci = sat position in eci 
% sun_position = the position of the sun relative to the earth
% parfor starts a parralel processing pool to speed up this step
parfor c = 1:col
    utc = mission.StartDate + c * seconds(sampletime);
    sat_eci(:,c) = ecef2eci(utc,pos(:,c),vel(:,c));
    sun_position(:,c) = approxECISunPosition(mission.StartDate + c * seconds(sampletime));
    disp(c)
end

% sat_vector = creates the vector from satellite to sun
for x = 1:col
    sat_vector(:,x) = sun_position(:,x) - sat_eci(:,x);
end


for y = 1:col

    sun_earth_distance(:,y) = norm(sun_position(:,y));
    sat_sun_distance(:,y) = norm(sat_vector(:,y));
    earth_sat_distance(:,y) = norm(sat_eci(:,y));
end

writematrix(sun_earth_distance,'sun_earth_distance.csv')
writematrix(sat_sun_distance, 'sat_sun_distance.csv')
writematrix(earth_sat_distance,'earth_sat_distance.csv')