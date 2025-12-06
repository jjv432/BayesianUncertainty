function [handles] = runUQ(data, initVals, initNames, mass, yIdeal, set)
    %% Uncertainty Analysis

    addpath('mcmcstat')
    addpath('kde')

    % data should be struct of data.x and data.y
    % data.xdata should be simtime

    %define initial guess for parameters
    % this is just init

    %model parameter range
    params = {};
    for i = set
        params{i,1} = initNames{i};
        params{i,2} = initVals(i);
        params{i,3} = 0;
        params{i,4} = inf;
    end

    A = params;  % example 6x4 cell array
    B = cell(size(A,1),1);  % preallocate 6x1

    for i = 1:size(A,1)
        paramsS{i} = A(i,:);  % store the entire row as a 1x4 cell
    end

    params = paramsS(:);
    %%
    % Call function that computes the error between the model and data
    ssfun = @ModelSimulationCost;
    model.ssfun=ssfun;

    function Cost = ModelSimulationCost(fp, data)
        s = newSpring(fp(1), fp(2), fp(3), fp(4), mass, fp(5), fp(6));

        y = s.getResponse(data.xdata);

        Cost = sum( (y - yIdeal).^2 );

    end

    %%
    % The next lines of code check the initial parameter guesses prior to running
    % Bayesian parameter calibration to see of the values given reasonable
    % results with respect to the data.

    spring = newSpring(initVals(1), initVals(2), initVals(3), initVals(4), mass, initVals(5), initVals(6));
    y_model = spring.getResponse(data.xdata);

    figure(1)
    plot(data.xdata,data.ydata(:,:),'x','MarkerSize',3,'Linewidth',2)
    hold on
    plot(data.xdata,y_model,'r-','Linewidth',3)
    hold off
    xlabel('t (s)')
    ylabel('y (m)')
    legend('Data','Model','Location','NorthWest')
    % saveas(gcf, "Reports/UQPlots/InitialGuess.jpg");
    handles.h1 = gcf;
    %%
    % The Bayesian analysis is calculated here.
    %%
    model.sigma2 = 1e-4;      %initial guess on variance
    model.S20 = model.sigma2; %prior for sigma2
    model.N0  = 1;            %prior accuracy for S20
    options.updatesigma = 1;  %update variance as part of the inference
    options.method = 'dram';  %this applies the DRAM algorithm
    model.N  = length(data.xdata); %number of data points

    options.nsimu = 5e4; %number of iterations in the Metropolis method
    [results, chain, s2chain]= mcmcrun(model,data,params,options);
    chainstats(chain,results) %print chain statistics

    %%
    % Plot the statistical results.  Note that Figure 4 containing pair
    % correlations will not plot except for the nonlinear case where there is
    % more than one parameter.

    figure(2)
    mcmcplot(chain(:,:),[],results,'denspanel',2);
    % saveas(gcf, "Reports/UQPlots/Chains.jpg");
    handles.h2 = gcf;

    figure(3); clf
    mcmcplot(chain(:,:),[],results.names,'chainpanel')
    xlabel('Iterations','Fontsize',24)
    ylabel('Parameter value','Fontsize',24)
    % saveas(gcf, "Reports/UQPlots/ChainPanel.jpg");
    handles.h3 = gcf;

    figure(4)
    mcmcplot(chain,[],results,'pairs');
    saveas(gcf, "Reports/Pairs.jpg");
    handles.h4 = gcf;
    %%
    % Compute the credible and prediction intervals

    % modelfun1 = @(d,th)mass_spring_model_Bayesian(th,d); % NOTE: the order in which d and th appear is important
    % 
    % nsample = 500; %number of sample iterations of the model used to construct the interval bounds
    % %the default interval bounds are 95% prediction/credible
    % %bounds
    % out = mcmcpred(results,chain,s2chain,data.xdata,modelfun1,nsample);
    % figure(5)
    % modelout = mcmcpredplot(out);
    % hold on
    % plot(data.xdata,data.ydata,'.','linewidth',1)
    % hold off
    % xlabel('t (s)','Fontsize',24);
    % ylabel('\delta (mm)','Fontsize',24);
    % legend('95% Prediction Interval','95% Credible Interval','Model Fit','Simulated Data','Location','Best')
    % saveas(gcf, "../Reports/UQPlots/Confidence.jpg");
    % handles.h5 = gcf;

end
