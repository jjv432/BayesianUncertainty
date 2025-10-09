function [Chi] = mass_spring_model_sensitivity(tmin,xdata);

y0 = tmin(1);
wn = tmin(2);
C = tmin(3);
t = xdata;

%y_model = y0*cos(wn*t);
Chi = y0/2.*exp(-C*t/2).*(C*t./(4*wn^2 - C^2).^0.5.*sin((wn^2-C^2/4).^0.5*t)...
       -t.*cos((wn^2-C^2/4).^0.5.*t));


Chi = Chi(:);
