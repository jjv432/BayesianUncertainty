function os = runOptimization(mass, simTime, yIdeal, tIdeal)

    %% Setting up GA

    % lower and upper bounds for each variable
    % L, t, w, r, (m), alpha
    
    
    LB= [0, 0, 0, 0, 0] + 1e-3;
    UB= [0.5, 0.5, 0.5, 0.5, 10];

    nvars = numel(LB);

    numparticles = 128;

    options = optimoptions('ga', 'PopulationSize', numparticles, 'MaxGenerations', 400);

    % Cost function handle
    costFunctionHandle = @(freeParams) ModelSimulationCost(freeParams, yIdeal);

    function Cost = ModelSimulationCost(fp, yIdeal)
        s = newSpring(fp(1), fp(2), fp(3), fp(4), mass, fp(5));

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
    os = newSpring(op(1), op(2), op(3), op(4), mass, op(5));

    [yOptimized, t_out] = os.getResponse(simTime);

    %% Plotting optimized

    figure;
    hold on
    plot(t_out, yIdeal, "LineWidth", 10)
    plot(t_out, yOptimized, '*k')
    xlabel("Time (s)");
    ylabel("Spring Height (m)");
    title("Real and Ideal Spring Response");
    grid on
    % saveas(gcf, "/Reports/Reduced_RealAndIdealSpringResponse.jpg");
    hold off

end