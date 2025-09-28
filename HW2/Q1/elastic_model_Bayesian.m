function [s_model] = elastic_model_Bayesian(tmin,xdata);

E = tmin(1);
E2 = tmin(2); %higher order elastic effect, ******NONLINEAR*******

s_model = E*xdata; %linear stress model
s_model = E*xdata + E2*xdata.^3; %nonlinear stress model, *****NONLINEAR*****
s_model = s_model(:);
