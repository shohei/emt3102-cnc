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
    plot(Xii(1:idx)-1,Yii(1:idx),'b');        
    big;
    drawnow;
end
legend('指令円軌跡','補間後加減速','補間前加減速');

figure();
plot(ts,Xii-1,'b');
hold on ;
plot(ts,Xo,'r');
title('X axis');
legend('補間前','補間後');

figure();
plot(ts, Yii,'b');
hold on;
plot(ts, Yo, 'r');
title('Y axis');
legend('補間前','補間後');

big;
