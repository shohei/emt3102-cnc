clear; close all; clc;

tau = 1;%s
wc = 1;%rad/s
Rc = 1;
theta_s = 0;%rad

out = sim('circle_MAfilt_post.slx');
ts = out.ts.Data;
Xo = out.Xo.Data;
Yo = out.Yo.Data;
Xi = out.Xi.Data;
Yi = out.Yi.Data;

Xii = out.Xii.Data;
Yii = out.Yii.Data;

figure();
hold on;

for idx=1:length(ts)
    axis equal;    
    plot(Xi(1:idx),Yi(1:idx),'g--');
    plot(Xo(1:idx),Yo(1:idx),'r');
    plot(Xii(1:idx),Yii(1:idx),'b');        
    big;
    drawnow;
end
legend('Circular interpolation', ...
    'ADCAI', ...
    'ADCBI');

figure();
plot(ts,Xo,'r');
hold on ;
plot(ts,Xii,'b');
title('X axis');
legend('ADCAI','ADCBI');
big;

figure();
plot(ts, Yo, 'r');
hold on;
plot(ts, Yii,'b');
title('Y axis');
legend('ADCAI','ADCBI');
big;
