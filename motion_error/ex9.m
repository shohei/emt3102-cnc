clear; close all; clc;
% load_params;
% FBtype = 1;% 1: Semi-close
%FBtype = -1; %-1: Full-close

% Ct = 1.0e4;%N•s/m
% Db = 0.05; %N•m•s/rad
% Dm = 0; %N•m•s/rad
% 
% Jr = 2.22e-3; %kg•m^2
% Ja = 2.72e-2; %kg•m^2
% Kt = 1.1e8;%N/m
% Mt = 100;%kg
% R = 3.2e-3; %m/rad
% 
% Dr = 0;%回転の粘性摩擦係数
% KT = 1;%トルク定数
% Wvc = 400;
% Kvi = Wvc/5;
% Kpp = Wvc/10;
% Kvp = Ja*Wvc/KT;

tau = 0.1;
slk1 = 'linear_acceleration';
[A B C D] = linmod(slk1);
sys1 = ss(A,B,C,D);
[Xout1, t] = lsim(sys1,0,0);

tlast = 0.6;
dt = 0.01;
ts = 0:dt:tlast;




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

vfb_on = 1;
pfb_on = 1;
FBtype = 1;

slk = 'c_ff_pvcm_2dof_ax1';
[A B C D] = linmod(slk);
sysT = ss(A,B,C,D);
[Xout, t] = lsim(sysT, Vrx, tri);
xr = Xout(:,1);
xm = Xout(:,2);
xt = Xout(:,3);

emx = (xm-xr);%deviation at motor
etx = (xt-xr);%deviation at table


