clear all
close all
run('AssembleC1_DataFile.m') %load the datafile of AssembleC1
rel_tol = 1E-3;% relative tolerance
tmax = 3000; %s, simulation time 
Vmax = 5; %V, max motor voltage
Kss = 125.6; %rad/Vs, steady-state gain 
tau = 590.2; %s, time constant 

theta_f = deg2rad(30); %  deg to rad , slew angle 
tdur = 300; % s time duration 
Is=0.02; % kgm^2, largest momentum of inertia

T2new=(4*theta_f*Is)/(tdur)^2; % Nm, (eqn 2) in project notes
H1new = 2*theta_f*Is/tdur; %Nms, (eqn3)
npoints = 30000; % minimun number of points include 
OPTIONS = simset('Maxstep',tmax/npoints); %maxium step set
out= sim('RW_motor_test_C1.slx',tmax,OPTIONS); %run simulink

%plot for yaw rw 5v response, roll rw response , maximum Angular velocity
%1/2 orbital period
figure(1)
plot(out.RW(:,1),out.RW(:,2),'k-','LineWidth',1)
hold on 
plot(out.RW(:,1),out.RW(:,3),'r--','LineWidth',1)
hold on
yline(Kss*Vmax,':','LineWidth',1)
hold on 
plot(tau*5,0,'d','MarkerEdgeColor','b','MarkerSize',5)
ylabel('RW Angular Velocity (rad/s)','FontSize',12)
xlabel('Time (s)','FontSize',12)
legend('Yaw RW 5V step response','Roll RW response from torque',...
    'Maximum RW Angular Velocity','1/2 orbital period')

Tmax= max(out.RW(:,5)); % the maxmium motor torque 
%figure 2 plot the calculated torque, maximum torque, T2new 
figure(2)
plot(out.RW(:,1),out.RW(:,5),'k-','LineWidth',1)
hold on,
plot(0,Tmax,'d','MarkerEdgeColor','b','MarkerSize',5)
hold on 
%plot T2new 
m=3; %aviod the ending point of T2new line  at the starting period    
%iterration  to plot a horizantal line and stop when contact with RW(:,5) line
while out.RW(m,5) > T2new 
    m=m+1;
end

plot([out.tout(1),out.tout(m)],[T2new,T2new], 'r:','LineWidth',1)%plot T2new
ylabel('Actuator Torque(Nm)','FontSize',12)
xlabel('time(s)','FontSize',12)
legend('Calculated Torque','Maximum (Starting) motor torque Tmax','Torque level for slew T2new')
%figure 3 plot the torque vs speed 
figure(3)
plot(out.RW(:,2),out.RW(:,5),'b-','LineWidth',1)
ylabel('torqure （Nm)','FontSize',12)
xlabel('speed (rasd/s)','FontSize',12)
legend('torque-speed curve')

publish('RW_motor_test_drv_C1.m','doc');
