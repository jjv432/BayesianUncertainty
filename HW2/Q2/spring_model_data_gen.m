clear all

wn = 100*pi;
C = wn/10;
y0 = pi/2;
tf = 0.2;
dt = tf/200;
t = 0:dt:tf;
noise = y0/10*randn(length(t),1)';
y_data = y0*cos(wn*t) + noise;
y_data2 = y0*exp(-C*t/2).*cos((wn^2-C^2/4).^0.5*t)+noise;

save spring_model_data y_data y_data2 t