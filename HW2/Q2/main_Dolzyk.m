clear all
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%
% The following line of code loads a previously generated set of fictitious data.
%%

load spring_model_data %this is a set of stress-strain data 

%%
% Put stress and strain into a data structure for the Bayesian analysis.
% Also define an initial guess for the elastic properties.
%%

data.ydata = y_data; %Displacement
data.xdata = t; %Time
data.xdata = data.xdata(:);
data.ydata = data.ydata(:);

%define initial guess for Landau parameters
C = 0.32785;
yo = 1.61;
wn = 314;


theta = [C
		wn
        yo];

%model parameter range
params = {
    {'C', theta(1), 0, 10}
    {'wn', theta(2),0, 500}	
	{'yo', theta(3),0, 5}
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

[displacement] = spring_damper_function_Dolzyk(theta,data.xdata);

figure(1)
plot(data.xdata,data.ydata,'bo:','MarkerSize',3,'Linewidth',2)
hold on
plot(data.xdata,displacement,'r-','Linewidth',3)
hold off
xlabel('Time (s)')
ylabel('Displacement(m)')
legend('Data','Model','Location','NorthWest')

% % Residual
% residual = sig_data - E*epsilon
% figure(8)
% plot(data.xdata,residual)
% xlabel('\epsilon (m/m)')
% ylabel('residual (MPa)')
% legend('\epsilon = 5000e-6','Model','Location','NorthEast')
%%
% The Bayesian analysis is calculated here.
%%

model.sigma2 = 1e-4;      %initial guess on variance
model.S20 = model.sigma2; %prior for sigma2
model.N0  = 1;            %prior accuracy for S20
options.updatesigma = 1;  %update variance as part of the inference
options.method = 'dram';  %this applies the DRAM algorithm
model.N  = length(data.xdata); %number of data points

options.nsimu = 15000; %number of iterations in the Metropolis method
[results, chain, s2chain]= mcmcrun(model,data,params,options);
chainstats(chain,results) %print chain statistics

save msd_Dolzyk results chain s2chain
%%
% Plot the statistical results.  Note that Figure 4 containing pair
% correlations will not plot except for the nonlinear case where there is
% more than one parameter.
%%

figure(2)
mcmcplot(chain,[],results,'denspanel',2);

figure(3); clf
mcmcplot(chain,[],results.names,'chainpanel')
xlabel('Iterations','Fontsize',24)
ylabel('Parameter value','Fontsize',24)

figure(4)
mcmcplot(chain,[],results,'pairs');

%%
% Compute the credible and prediction intervals
%%

modelfun1 = @(d,th)spring_damper_function_Dolzyk(th,d); % NOTE: the order in which d and th appear is important

nsample = 500; %number of sample iterations of the model used to construct the interval bounds
               %the default interval bounds are 95% prediction/credible
               %bounds
out = mcmcpred(results,chain,s2chain,data.xdata,modelfun1,nsample);
figure(5)
modelout = mcmcpredplot(out);
hold on
plot(data.xdata,data.ydata,'b.--','linewidth',1)
hold off
xlabel('time [s]','Fontsize',24);
ylabel('displacement (m)','Fontsize',24);
legend('95% Prediction Interval','95% Confidence Interval','Model Fit','Simulated Data','Location','Best')


residual = displacement - data.ydata;
figure(6)
plot(data.xdata,residual)
xlabel('time(s)')
ylabel('residual (m)')
legend('residual - 10000 simul.','Model','Location','NorthEast')
