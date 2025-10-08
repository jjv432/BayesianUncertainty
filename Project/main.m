clc; close all; clearvars
%% 
L = 5;
l = 1;

links(1) = linkage('r', L, l, 'r');
links(2) = linkage('l', L, l, 'k');
links(3) = linkage('r', L, l, 'c');

%% Animating
xmin = -L-1;
xmax = 1;
ymin = -l-1;
ymax = 2*L;

figure()
hold on
fill([xmin xmin xmax  xmax], [-1 0 0 -1], 'b', 'FaceAlpha', .5);
axis equal
axis padded
axis([xmin, xmax, ymin, ymax]);

offset = pi/20;
thetas = linspace(pi/2 - offset, pi/2 + offset, 250);
linkageOffset = 0;

% Animate every theta
for i = 1:numel(thetas)
    links(1) = links(1).plotLinkage(thetas(i));

    % animate each link
    for j = 2:numel(links)
        links(j).basePosition = links(j-1).endPosition;
        % lhs links need to have mirrored thetas
        if links(j).handedness == 'l'
            links(j) = links(j).plotLinkage(pi-thetas(i));
        else
            links(j) = links(j).plotLinkage(thetas(i));
        end
    end

    pause(.001);
    
    % Delete all the plots to make it smooth
    for k = 1:numel(links)
        delete(links(k).figs);
    end
end


