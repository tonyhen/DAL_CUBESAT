%satellite_slew_drv

clear all
close all

%run data file
run('AssembleC1_DataFile.m')

%Given
%tmax = 900; %s, maximum simulation time 
Vmax = 5; %V, max motor voltage
Kss = 125.6; %rad/Vs, steady-state gain 
tau = 573.3; %s, time constant 
r = 6.93E6; %m, oribit
mu = 3.986E14; %m^3/s
period = 2*pi*sqrt(r^3/mu); %period of satellite
velocity = sqrt(mu/r); %velocity of satellite

tmax = period; %s, for disturbance torque analysis

%Manually tuned PD control grains
Kp = 1000;
Kd = 1000;
Ki = 0;

%Worst case disturbance
Tworst = 0;
%Tworst = 5.078*10^(-7);
T1 = 5*Tworst;
disturbance = [period 0 0 T1];

%Torque required for RW to meet slew requirement
thetaf = deg2rad(30); %rad, slew angle 30 deg
tdur = 300; %seconds, 5 minutes
Is =0.02; %kg*m^2, largest moment of inertia 
T2 = 4*thetaf*Is/tdur^2; 

%slew 1 time
t1 = (0:0.1:149.99)';
t2 = (150:0.1:299.99)';
%slew 2 time
t3 = (300:0.1:449.99)';
t4 = (450:0.1:599.99)';
%slew 3 time
t5 = (600:0.1:749.99)';
t6 = (750:0.1:899.99)';
%stitch times together
time = [t1; t2];
time2 = [t3; t4];
time3 = [t5; t6];

%angular position vs time
theta1 = (T2.*t1.^2)/(2*Is); %Attitude equation for acceleration portion
theta2 = theta1(numel(theta1))+(2*T2*t1(numel(t1)))/(2*Is)*(t2-t1(numel(t1)))-(T2*(t2-150).^2)./(2*Is);
%stitich angular positions together
theta = [theta1; theta2];

%desired attitude matrix
zero = zeros(3000,1); %zero matrix
one =ones(3000,1); %one matrix 
slew = pi/6*one; %keep desired altitude after performing maneuver
des_att =...
[time  zero  zero  theta;
time2 zero  theta slew;
time3 theta slew  slew];

%for worst case torque analysis
%des_att = ...
%    [time zero zero zero];


%simulate the system
npoints = 9000; % minimun number of points include 
OPTIONS = simset('Maxstep',tmax/npoints);
out= sim('satellite_slew.slx',tmax,OPTIONS);

%plot outputs
%Yaw
figure(1)
subplot(4,1,1)
plot(out.speed(:,1),out.speed(:,4))
xlabel('Simulation Time (s)','FontSize',12)
ylabel('Speed (rad/s)','FontSize',12)
title('Yaw RW Speed','FontSize',12)
subplot(4,1,2)
plot(out.torque(:,1),out.torque(:,4))
xlabel('Simulation Time (s)','FontSize',12)
ylabel('Torque (Nm)','FontSize',12)
title('Yaw RW Torque','FontSize',12)
subplot(4,1,3)
plot(out.attitude(:,1),out.attitude(:,4))
xlabel('Simulation Time (s)','FontSize',12)
ylabel('Angle (rad)','FontSize',12)
title('Satellite Yaw','FontSize',12)
subplot(4,1,4)
plot(out.voltage(:,1),out.voltage(:,4))
xlabel('Simulation Time (s)','FontSize',12)
ylabel('Voltage (V)','FontSize',12)
title('Yaw RW Motor Voltage','FontSize',12)

%Pitch
figure(2)
subplot(4,1,1)
plot(out.speed(:,1),out.speed(:,3))
xlabel('Simulation Time (s)','FontSize',12)
ylabel('Speed (rad/s)','FontSize',12)
title('Pitch RW Speed','FontSize',12)
subplot(4,1,2)
plot(out.torque(:,1),out.torque(:,3))
xlabel('Simulation Time (s)','FontSize',12)
ylabel('Torque (Nm)','FontSize',12)
title('Pitch RW Torque','FontSize',12)
subplot(4,1,3)
plot(out.attitude(:,1),out.attitude(:,3))
xlabel('Simulation Time (s)','FontSize',12)
ylabel('Angle (rad)','FontSize',12)
title('Satellite Pitch','FontSize',12)
subplot(4,1,4)
plot(out.voltage(:,1),out.voltage(:,3))
xlabel('Simulation Time (s)','FontSize',12)
ylabel('Voltage (V)','FontSize',12)
title('Pitch RW Motor Voltage','FontSize',12)

%Roll
figure(3)
subplot(4,1,1)
plot(out.speed(:,1),out.speed(:,2))
xlabel('Simulation Time (s)','FontSize',12)
ylabel('Speed (rad/s)','FontSize',12)
title('Roll RW Speed','FontSize',12)
subplot(4,1,2)
plot(out.torque(:,1),out.torque(:,2))
xlabel('Simulation Time (s)','FontSize',12)
ylabel('Torque (Nm)','FontSize',12)
title('Roll RW Torque','FontSize',12)
subplot(4,1,3)
plot(out.attitude(:,1),out.attitude(:,2))
xlabel('Simulation Time (s)','FontSize',12)
ylabel('Angle (rad)','FontSize',12)
title('Satellite Roll','FontSize',12)
subplot(4,1,4)
plot(out.voltage(:,1),out.voltage(:,2))
xlabel('Simulation Time (s)','FontSize',12)
ylabel('Voltage (V)','FontSize',12)
title('Roll RW Motor Voltage','FontSize',12)

