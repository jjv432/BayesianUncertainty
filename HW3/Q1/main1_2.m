clear all; clc; close all

%%
% The following line of code loads a previously generated set of fictitious data.
%%
addpath('mcmcstat')
addpath('kde')

load mixed_oscillator2  %this is a set of dynamic data

%%
data.ydata = y_mixed(:,1:20)'; %adjust the number of columns to evaluate the
%statistical model
data.xdata = t;
data.xdata = data.xdata(:);

%define initial guess for parameters
z0 = 1.5;
k = 1e5;
C = 30;
m = 1;

theta = [z0
    k
    C
    ];

%model parameter range
params = {
    {'z_0', theta(1), 0, inf}
    {'k', theta(2),0,inf}
    {'C', theta(3),0,inf}
    };

%%
% The Bayesian analysis is calculated here.

dataSamples = [1 3 5 16 20];
ssfun = @SS_func;
model.ssfun=ssfun;
model.sigma2 = 1e-4;      %initial guess on variance
model.S20 = model.sigma2; %prior for sigma2
model.N0  = 1;            %prior accuracy for S20
options.updatesigma = 1;  %update variance as part of the inference
options.method = 'dram';  %this applies the DRAM algorithm

for i = 1:numel(dataSamples)
    curData = data;
    curData.ydata = curData.ydata(i, :);
    runPlotDRAM(curData, params, model);
    fig = gcf;
    savefig(fig, 'orig' + string(i) + '.fig');
    close
end

h1x = [29.5 30.5];
h2x = [9.8*10^4, 10.15*10^4];
h3x = [1.48 1.52];

for i = 1:5
    fig = openfig('orig' + string(i) + '.fig');
    h = findobj(fig, 'type', 'axes');
    set(h(3), 'XLim', h3x);
    set(h(2), 'XLim', h2x);
    set(h(1), 'XLim', h1x);

    saveas(gcf, "densityColumn" + string(i) + ".jpeg");
end

function runPlotDRAM(data, params, model)

    model.N  = length(data.xdata); %number of data points

    options.nsimu = 50000; %number of iterations in the Metropolis method
    [results, chain]= mcmcrun(model,data,params,options);
    chainstats(chain,results) %print chain statistics

    % Plot results
    figure()
    mcmcplot(chain(:,:),[],results,'denspanel',2);
end