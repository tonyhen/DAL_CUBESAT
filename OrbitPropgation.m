mission.StartDate = datetime(2020, 11, 30, 22, 23, 24);
mission.Duration  = mission.StartDate + hours(3);
sampletime = 1;
dy = decyear(mission.StartDate);

sc = satelliteScenario(mission.StartDate, mission.Duration, sampletime);


tle = 'ISS.tle';
iss = satellite(sc, "ISS.tle");

v = satelliteScenarioViewer(sc);
pos = states(iss,"CoordinateFrame","geographic");
pos_ecef = states(iss,"CoordinateFrame","ecef");
for c = 1:10801
    [xyz(:,c),H(:,c),D(:,c),I(:,c),F(:,c)] = wrldmagm(pos(3,c),pos(1,c),pos(2,c), dy,'2020');
end
 
%total is the combined position and magnetic data for a 3 hour length of
%the space station,Position(1:3), Fieldvector (4:6),Horizontal Intensity(7),
%Declination(8), Inclination(9), Total Intensity(10).
total=cat(1,pos_ecef,xyz,H,D,I,F);

