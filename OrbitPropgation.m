% Please make the number of days reasonable for your computers. Recommend
% 30 

mission.StartDate = datetime(2020, 11, 30, 22, 23, 24);
mission.Duration  = mission.StartDate + days(365);
% Sample time is in seconds 
sampletime = 60;
dy = decyear(mission.StartDate);
sc = satelliteScenario(mission.StartDate, mission.Duration, sampletime);

% TLE is the two line element file for the ISS 
tle = 'ISS.tle';
sat = satellite(sc, "ISS.tle");
base = groundStation(sc, 44.6476, -63.5728);
ac = access(sat, base);
re = 6371000;

%v = satelliteScenarioViewer(sc);
%intvls = accessIntervals(ac);

% Pulls the state of the satellite in ECEF coordinate frame 
[pos,vel] = states(sat,"CoordinateFrame","ecef");
[row,col] = size(pos);
sun = zeros(3,col);

%Outputs the data as a csv so to cut down on runtime
writematrix(pos,'pos.csv')
writematrix(vel,'vel.csv')

