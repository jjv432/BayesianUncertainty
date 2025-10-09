function [ss] = SS_func(theta,data)

ydata = data.ydata;

xdata = data.xdata;

[y_model] = mass_spring_model_Bayesian(theta,xdata);
% size(y_model')
% size(ydata)
ss = sum(sum((y_model' - ydata).^2));

