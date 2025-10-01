clc; close all; clearvars
%{
Need to add the extra bits at the end of each linkage
%}
L = 5;
l = 1;
% link1 = linkage('r', L, l, 'r');
% link2 = linkage('l', L, l, 'k');
% link3 = linkage('r', L, l, 'c');
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
for i = 1:numel(thetas)
    links(1) = links(1).plotLinkage(thetas(i));
    for j = 2:numel(links)
        links(j).basePosition = links(j-1).endPosition;
        if mod(j,2) == 0
            links(j) = links(j).plotLinkage(pi-thetas(i));
        else
            links(j) = links(j).plotLinkage(thetas(i));
        end
    end

    pause(.001);
    for k = 1:numel(links)
        delete(links(k).figs);
    end
end


