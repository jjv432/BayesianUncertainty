clc; clearvars; close all
tf = 30;
dt = tf/1e2;
t = 0:dt:tf;
a = 0.5;
z0 = 1;

z_th = z0 * exp(-a*t);

%% Central difference (?)
n= length(t);
z(1) = z0;
for i =1:length(t) -1
    z(i+1) = 1/(1+dt/2*a)*(1-dt/2*a)*z(i);
end



%% Plot
figure()
hold on
plot(t,z_th, 'b-*', 'DisplayName', 'Theoritcal')
plot(t,z, 'r-', 'DisplayName', 'Numerical')
xlabel('Time')
ylabel('z(t)')

%% Complex Step
zdot_th = -a*z0*exp(-a*t);

h = 1e-3;
z_cs = z0*exp(-a*(t+1i*h));
dz_dtc = imag(z_cs)/h;

figure()
hold on
plot(t,zdot_th, 'b', 'DisplayName', 'Theory')
plot(t,dz_dtc, '*k',  'DisplayName', 'Complex')
xlabel("Time")
ylabel("zdot_{th}(t)")
legend()


za_cs = z0*exp((a+1i*h)*t);
dza = imag(za_cs)/h;
dza_th = -t.*z0.*exp(-a*t); % theory


figure()
hold on
plot(t,dza_th, 'b', 'DisplayName', 'Theory')
plot(t,dza, '*k',  'DisplayName', 'Complex')
xlabel("Time")
ylabel("zdot_{th}(t)")
legend()

