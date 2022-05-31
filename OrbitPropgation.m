mission.StartDate = datetime(2020, 11, 30, 22, 23, 24);
mission.Duration  = mission.StartDate + hours(24);
sampletime = 10;


sc = satelliteScenario(mission.StartDate, mission.Duration, sampletime);


tle = 'ISS.tle';
iss = satellite(sc, "ISS.tle");

%v = satelliteScenarioViewer(sc);

for i=1:NumRows