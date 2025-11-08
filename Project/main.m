clc; clearvars; close all

addpath("./src");
% 
% c = connector(4, 1, 'r');
% 
% c.plotConnector(-1,-1, pi/4);
% 
% e = elbow;
% 
% F_vals = linspace(500, 5000, 5);
% figure()
% e.plotMultipleAngularChanges(F_vals);

connectorParams.length = 4;
connectorParams.thickness = 1;

elbowParams.t = 2;
elbowParams.w = 10;
elbowParams.r = 2;
elbowParams.E = 1E5;


s = spring(4, connectorParams, elbowParams);

s.generateConnectors();  % This creates all the connector objects and initializes their coordinates
s.generateElbows();

s.constructSpring();
s.plotSpring();