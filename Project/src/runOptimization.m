function [os, handle] = runOptimization(mass, simTime, yIdeal, tIdeal, paramsToVary)

    %% Setting up GA

    % lower and upper bounds for each variable
    % L, t, w, r, (m), alpha, E


    possibleLB= [0, 0, 0, 0, 0, 5e8] + 1e-3;
    possibleUB= [0.5, 0.5, 0.5, 0.5, 10, 1e10];

    LB = possibleLB(paramsToVary);
    UB = possibleUB(paramsToVary);

    nvars = numel(LB);

    numparticles = 128;

    options = optimoptions('ga', 'PopulationSize', numparticles, 'MaxGenerations', 800, 'UseParallel', true);

    possibleStates = 1:6;
    constantState = ismember(possibleStates, paramsToVary);
    constants(1:6) = [0.41, 6e-3, .49, .3, 7.7, 9e9];


    % Cost function handle
    costFunctionHandle = @(freeParams) ModelSimulationCost(freeParams, yIdeal);

    function Cost = ModelSimulationCost(fp, yIdeal)
        p = [];
        ctr = 1;
        for i = possibleStates(1):possibleStates(end)
            if (constantState(i) == 0)
                p(i) = constants(i);
            else
                p(i) = fp(ctr);
                ctr = ctr +1;
            end
        end

        s = newSpring(p(1), p(2), p(3), p(4), mass, p(5), p(6));

        y = s.getResponse(simTime);

        Cost = sum( (y - yIdeal).^2 );

    end
    %% Run GA
    % Running ga
    A = [];
    b = [];
    Aeq = [];
    beq = [];
    nonlcon = [];
    op = ga(costFunctionHandle, nvars, A, b, Aeq, beq, LB, UB, nonlcon, options);

    %% Create the optimal spring
    ctr = 1;
    opt = [];
    for i = possibleStates(1):possibleStates(end)
        if (constantState(i) == 0)
            opt(i) = constants(i);
        else
            opt(i) = op(ctr);
            ctr = ctr +1;
        end
    end

    os = newSpring(opt(1), opt(2), opt(3), opt(4), mass, opt(5), opt(6));

    [yOptimized, t_out] = os.getResponse(simTime);

    %% Plotting optimized

    figure;
    hold on
    plot(t_out, yIdeal, "LineWidth", 10, 'DisplayName', 'Ideal')
    plot(t_out, yOptimized, '*k', 'DisplayName', 'Model')
    xlabel("Time (s)");
    ylabel("Spring Height (m)");
    title("Real and Ideal Spring Response");
    grid on
    hold off
    legend();
    handle.h1 = gcf;

    figure;
    hold on
    plot(t_out, 100*(yOptimized - yIdeal)./(yIdeal), '.k', "MarkerSize", 5)
    xlabel("Time (s)");
    ylabel("Percent Error");
    ylim([-30, 30]);
    title("Real and Ideal Spring Response");
    grid on
    hold off
    handle.h2 = gcf;
end