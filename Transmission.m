
%Mission Simulation Parameters
mission.StartDate = datetime(2020, 11, 30, 22, 23, 24);
mission.Duration  = mission.StartDate + days(30);
% Sample time is in seconds 
sampletime = 3;
dy = decyear(mission.StartDate);
sc = satelliteScenario(mission.StartDate, mission.Duration, sampletime);
%Satellite Scenario Parameters 
 
tle = 'ISS.tle';
sat = satellite(sc, "ISS.tle");
base = groundStation(sc, 44.6476, -63.5728);
ac = access(sat, base);

%Transmitter details
frequency = 4.38e8;                 % Hz
power = 3.0;                        % dBW
bitRate = 4.0;                      % Mbps
systemLoss = 3;

%Gimbals on gs and sat 
gimbaltxsat = gimbal(sat);
gimbalrxgs = gimbal(base);
pointAt(gimbalrxgs,sat);
pointAt(gimbaltxsat,base)


txSat = transmitter(gimbaltxsat,Name="Satellite Transmitter",Frequency=frequency, ...
    power=power,BitRate=bitRate,SystemLoss=systemLoss);
rxGs = receiver(gimbalrxgs,Name="Ground Station Receiver",RequiredEbNo=requiredEbNo);


requiredEbNo = 14;                  % dB
dishDiameter = 5;                   % meters
gaussianAntenna(rxGs,DishDiameter=dishDiameter);


lnk = link(txSat,rxGs);

linkintvls = linkIntervals(lnk)
v = satelliteScenarioViewer(sc, Dimension ='2D');