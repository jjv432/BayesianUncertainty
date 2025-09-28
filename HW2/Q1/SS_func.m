function [ss] = SS_func(theta,data)

ydata_s_rand = data.ydata; %Pa

xdata = data.xdata;

[sig_model] = elastic_model_Bayesian(theta,xdata);
ss = sum((sig_model - ydata_s_rand).^2);