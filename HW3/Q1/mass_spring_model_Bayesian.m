function [y_model] = mass_spring_model_Bayesian(tmin,xdata);

y0 = tmin(1);
k = tmin(2);
C = tmin(3);
m = 1;%tmin(4);

wn = (k/m)^(0.5);
t = xdata;

%y_model = y0*cos(wn*t);
y_model = y0*exp(-C*t/2).*cos((wn^2-C^2/4).^0.5*t);


y_model = y_model(:);
