clear
% close all
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
addpath('mcmcstat')
nData = 25;
C = 1.5;
K = 10;
t = linspace(0,20,nData);
y_smooth = 2*exp(-C*t/2).*cos(sqrt(K-C^2/4)*t);
y = y_smooth+randn(1,numel(t))/20;

data.ydata = y; %stress in Pa
data.xdata = t; %strain in mm/mm
data.xdata = data.xdata(:);
data.ydata = data.ydata(:);

%define initial guess for parameters
theta = [C
        ];

%model parameter range
params = {
    {'C', theta(1), 0, inf}
    };

%%
% Call function that computes the error between the model and data 
%%

ssfun = @SS_func;
model.ssfun=ssfun;

%%
% The next lines of code check the initial parameter guesses prior to running
% Bayesian parameter calibration to see of the values given reasonable
% results with respect to the data.
%%

[y_m] = mass_spring_model_Bayesian(theta,data.xdata);

figure(1)
plot(t,y_m,'linewidth',3)
hold on
plot(t,y,'r.-')
hold off
xlabel('t')
ylabel('y')
%%
% The Bayesian analysis is calculated here.
%%

model.sigma2 = 1e-4;      %initial guess on variance
model.S20 = model.sigma2; %prior for sigma2
model.N0  = 1;            %prior accuracy for S20
options.updatesigma = 1;  %update variance as part of the inference
options.method = 'dram';  %this applies the DRAM algorithm
model.N  = length(data.xdata); %number of data points

options.nsimu = 20000; %number of iterations in the Metropolis method
[results, chain, s2chain]= mcmcrun(model,data,params,options);
chainstats(chain,results) %print chain statistics

figure(3); clf
mcmcplot(chain,[],results.names,'chainpanel')
xlabel('Iterations','Fontsize',24)
ylabel('Parameter value','Fontsize',24)

%%
% Plot the statistical results

figure(10)
nFreq = 1000;
sigma02 = sum((y'-y_m).^2)/(numel(t)-1);
a = sqrt(K-C^2/4);
X = exp(-C*t/2).*((C/(2*a)*sin(a*t) - t.*cos(a*t)));
X = X';
V = sigma02*(X'*X)^(-1);
lb = mean(chain)-1;
ub = mean(chain)+1;
x_vec = linspace(lb,ub,nFreq);
pd = exp(-(x_vec-mean(chain)).^2/(2*V))/(sqrt(V*2*pi));
hold on
mcmcplot(chain,[],results,'denspanel',2);
plot(x_vec,pd,'--')
legend('DRAM','Frequentist')
str = sprintf('Probability Distribution\n nData = %i\n',nData)
title(str)
% axis([1.4 1.6 0 inf])
hold off
