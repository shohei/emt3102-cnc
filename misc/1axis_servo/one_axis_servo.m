clear; close all;
slk1 = 'vcm';

Ja = 0.00196;
Da = 0;
KT = 0.912;
Wvc = 500;
Kvp = Ja*Wvc/KT;
n = 4;%Padé-approximation order
macro_txt = { 'Tdv=0;     Wcc=5*Wvc;Kvi=Wvc/5;%Case1;'
              'Tdv=0;     Wcc=2*Wvc;Kvi=Wvc/5;%Case2'
              'Tdv=0;     Wcc=5*Wvc;Kvi=Wvc/2;%Case3'
              'Tdv=1e-3;Wcc=5*Wvc;Kvi=Wvc/5;%Case4'};

lspec = {'-k','--r','-.g',':b'};
w=logspace(1,4,200);
t=0:0.001:0.03;

figure(1);
axh1 = subplot(211);
axh2 = subplot(212);

for ii=1:length(macro_txt)
    vfb_on = 0;
    eval(macro_txt{ii});
    [A1 B1 C1 D1] = linmod(slk1);
    sys1 = minreal(ss(A1,B1,C1,D1));
    [mag1 ph1] = bode(sys1, w);    
    mag1 = 20*log10(mag1(:));
    ph1 = ph1(:);
    if ii==4
        %Case4の位相はある周波数以降すべて-180°とする。
        ph1 = mod(ph1 + 180, 360) - 180;
        ph1(ph1>-100) = -180; %-100°を超えるものはすべて-180°
        ph1(180:end) = -180;%200サンプルのうち、180サンプル以降はすべて-180°
    end
    PM0(ii) = 90-180/pi*(atan(Wvc/Wcc)+atan(Kvi/Wvc)+Wvc*Tdv);
    [GM(ii),PM(ii),Wcg(ii),Wcp(ii)] = margin(sys1);
    axes(axh1); 
    semilogx(w,mag1,lspec{ii});
    hold on;
    axes(axh2);
    semilogx(w,ph1,lspec{ii});
    hold on;

    vfb_on = 1;
    [A1 B1 C1 D1] = linmod(slk1);
    sys2 = minreal(ss(A1,B1,C1,D1));
    [st1, tt1] = step(sys2,t);
    figure(2);
    plot(tt1, st1, lspec{ii});
    hold on;    
end

axes(axh1);
xlabel('\omega rad/s');
ylabel('Gain dB');
axis([10 10^4 -60 60]);
grid on;
legend(macro_txt{:});
axes(axh2);
xlabel('\omega rad/s');
ylabel('Phase');
figure(2);
xlabel('t s');
ylabel('t m/s');
axis([0 0.03 -0.2 1.6])
grid on;
legend(macro_txt{:});

big;
