clear; close all; clc;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Parameter for Linear acceleration
tau = 0.1;
n = 4;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Signal generation for X-axis
tlast = 2;
% tlast = 0.6;
dt = 0.01;
ts = 0:dt:tlast;

step_start = 0.01;
step_end = 0.3;
signal_in = zeros(size(ts));
VFC = 300.0;%mm/s
signal_in(ts>=step_start & ts<=step_end) = VFC;

slk1 = 'linear_acceleration';
[A B C D] = linmod(slk1);
sys1 = ss(A,B,C,D);
[Vrx, t] = lsim(sys1,signal_in,ts);
plot(ts, signal_in);
hold on;
plot(t, Vrx);
grid on;
legend('Velocity input','Filtered velocity');
title('Velocity command');

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
FBtype = -1;%semi-closed positon feedback
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% X-axis servo simulation
slk = 'c_ff_pvcm_2dof_ax1_2';
[A B C D] = linmod(slk);
sysT = ss(A,B,C,D);
[Xout, t] = lsim(sysT, Vrx, t);
xr = Xout(:,1);
xm = Xout(:,2);
xt = Xout(:,3);
Kt_out = Xout(:,4);
emx = xm-xr;%motor error
etx = xt-xr;%table error
figure();
plot(t,xr);
hold on;
plot(t,xt);
legend('xr','xt');

figure();
plot(t,Kt_out);
title('KT');

% Signal input for Y-axis
Vry = Vrx;
% Y-axis servo simulation
Kvp = Kvp*1.05;
Kvi = Kvi*1.05;
Mt = Mt*2;
Ct = Ct*1.05;
[A B C D] = linmod(slk);
sysT2 = ss(A,B,C,D);
[Yout, t] = lsim(sysT2, Vry, t);
yr = Yout(:,1);
ym = Yout(:,2);
yt = Yout(:,3);
emy = ym-yr;%motor error
ety = yt-yr;%table error

% Motion error calculation
th = deg2rad(45);
en = -etx*sin(th)+ety*cos(th);

figure();
plot(t,etx);
hold on;
plot(t,ety);
legend('etx','ety');

figure();
plot(t, en);
legend('Table error et');

figure();
plot(xr,yr);
hold on;
scale = 1;
plot(xr+scale*etx,yr+scale*ety);
legend('Interpolation','Table position');


big;




