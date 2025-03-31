clear; close all; clc;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Parameter for 2DOF model

Mt = 100;%kg
Kt = 1.0e8;%N/m
Ct = 2.0e8;%N•s/m
Jr = 3.0e-2;%kg•m^2
Dr = 0;%N•m/srad
lp = 1e-2;%m
R = lp/2/pi; %m/rad

KT = 1;%N•m/A
Wvc = 240;%rad/s
Ja = Jr + Mt*R^2;%kg•m^2
Kvp = (Ja*Wvc)/KT;%rad/s velocity P gain
Kvi = 60;%rad/s velocity I gain
Kpp = 40;%rad/s position P gain
Kvf = 0.7;%[-] velocity feedback gain

vfb_on = 1;%velocity feedback ON
pfb_on = 1;%position feedback ON
FBtype = 1;%semi-closed positon feedback
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

tlast = 10;
dt = 0.01;
ts = 0:dt:tlast;
step_start = 0.01;
step_end = 0.3;
signal_in = zeros(size(ts));
VFC = 300.0;%mm/s
% signal_in(ts>=step_start & ts<=step_end) = VFC;
signal_in = ts*VFC;
signal_in(ts>=step_end) = ts(ts==step_end)*VFC;


slk = 'model_2dof_test';
[A B C D] = linmod(slk);
sysT = ss(A,B,C,D);
[Xout,t] = lsim(sysT, signal_in, ts);
subplot(311);
plot(ts,signal_in);
title('Motor torque input');
subplot(312);
plot(t,Xout(:,1));
hold on;
plot(t,Xout(:,2));
legend('motor','table');


big;
