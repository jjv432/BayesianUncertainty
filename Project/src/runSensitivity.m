function runSensitivity(mass, yIdeal, tIdeal, simTime, fixedPoint)

    %** Begin Finite Diff

    delta = .00005;
    numTestPoints = 300; % MUST BE EVEN

    % Each row is a param, each column is a test point
    Costs = zeros(numel(fixedPoint), numTestPoints -1);
    testPointMatrix = [];

    for i = 1:numel(fixedPoint) % Each parameter
        th_test = fixedPoint; % ensure that it remains the same

        th_i = th_test(i);
        min = th_i - delta*th_i;
        max = th_i + delta*th_i;

        th_i_minus = linspace(min, th_i, numTestPoints/2 + 1);
        tmp = th_i_minus(2) - th_i_minus(1);

        th_i_plus = linspace(th_i, max, numTestPoints/2 +1);
        

        testPoints = [th_i_minus, th_i_plus(2:end)];
        testPoints(testPoints <=0) = 1e-12;

        testPointMatrix = [testPointMatrix; testPoints];

        for j = 1:numel(testPoints) % Each test point for cur param
            th_test(i) = testPoints(j); % Test the point

            Costs(i, j) = ModelSimulationCost(th_test, yIdeal);

        end

    end

    %** Find sensitivities using the finit diff matrix
    % Find scaling factor
    y0 = ModelSimulationCost(fixedPoint, yIdeal);
    scaler = fixedPoint/y0;

    S = zeros(numel(fixedPoint), numTestPoints + 1);

    for k = 1:numel(fixedPoint)
        rMSE = (Costs(k,:) - y0) / y0;
        S(k, :) = rMSE / delta;
    end
    % for k = 1:(numTestPoints)
    %     S(:, k) = (Costs(:, k+1) - Costs(:, k)) / delta;
    % end
    % 
    % for j = 1:numel(fixedPoint)
    %     S(j, :) = S(j, :) * scaler(j);
    % end


    %** Plot sensitivities
    paramNames = ['L', 't', 'w', 'r', "\alpha", 'E'];
    figure('WindowState','maximized')
    for a = 1:numel(fixedPoint)
        subplot(3, 2, a);
        plot((testPointMatrix(a, :) - fixedPoint(a))/fixedPoint(a), S(a, :), 'k', "LineWidth", 3)
        ylabel("S (\theta_" + string(a) + ")", 'fontweight', 'bold');
        xlabel('%\Delta' + paramNames(a), 'fontweight', 'bold');
        grid on
        ax = gca; % Get the current axes object
        ax.FontSize = 14;
    end
    % sgtitle('Local Sensitivities');
    saveas(gcf, "Reports/LocalSens.jpg");

    %% Cost Function

    function Cost = ModelSimulationCost(fp, yIdeal)
        s = newSpring(fp(1), fp(2), fp(3), fp(4), mass, fp(5), fp(6));

        y = s.getResponse(simTime);

        Cost = sum( (y - yIdeal).^2 );

    end


end