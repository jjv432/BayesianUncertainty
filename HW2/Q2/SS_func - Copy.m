function [ss] = SS_func(theta,data)

ydata_y_rand = data.ydata; %displacements

xdata = data.xdata;

[y_model] = mass_spring_model_Bayesian(theta,xdata);
ss = sum((y_model - ydata_y_rand).^2);