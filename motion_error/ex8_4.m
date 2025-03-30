clear; close all; clc;
% load_params;

slk = 'c_pvcm_2dof_ax1';

% FBtype = 1;%1: Semi-close, -1: Full-close
FBtype = -1;%1: Semi-close, -1: Full-close

Ct = 1.0e4;%N•s/m
Db = 0.05; %N•m•s/rad
Dm = 0; %N•m•s/rad

Jr = 2.22e-3; %kg•m^2
Ja = 2.72e-2; %kg•m^2
Kt = 1.1e8;%N/m
Mt = 500;%kg
R = 3.2e-3; %m/rad

Dr = 0;%回転の粘性摩擦係数
KT = 1;%トルク定数
Wvc = 400;
Kvi = Wvc/5;
Kpp = Wvc/10;
Kvp = Ja*Wvc/KT;

vfb_on = 1;
pfb_on = 0;
[A B C D] = linmod(slk);
sysT = ss(A,B,C,D);
sys1 = minreal(sysT(1,1));
figure(1);
subplot(121);
rlocus(sys1);
zeta = [0 0.3 0.7 1.0];
wvec = 100:100:600;
sgrid(zeta, wvec);
axis([-300 50 -650 650]);
ax1 = gca;
hold on;

vfb_on = 1;
pfb_on = 1;
Kby = {'Kpp=Wvc/10','Kpp=Wvc/4'};
tlast = 0.1;
t1 = 0:5e-4:tlast;
lspec={':k','-b'};
mkspec = {'*','+'};
for ii=1:length(Kby)
    eval(Kby{ii});
    lgtext{ii} = ['Pole position',mkspec{ii},'(',Kby{ii},')'];
    [A,B,C,D] = linmod(slk);
    sysT = ss(A,B,C,D);
    [p1 z1] = pzmap(sysT(1,1));
    axes(ax1);
    plot(p1, mkspec{ii});
    Xm = step(sysT(2,1),t1);
    Xt = step(sysT(3,1),t1);
    subplot(222);
    plot(t1, Xm, lspec{ii});
    axR1 = gca;
    hold on;
    subplot(224);
    plot(t1, Xt, lspec{ii});
    axR2 = gca;
    hold on;  
end

axes(axR1);
ylabel('Response [-]');
xlabel('t s');
legend(lgtext{:});
axis([0 tlast 0 1.5]);
axes(axR2);
ylabel('Response [-]');
xlabel('t s');
legend(lgtext{:});
axis([0 tlast 0 1.5]);

big;