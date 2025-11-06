clc; clearvars; close all

addpath("./src");

c = connector(4, 1, 'l');

c.plotConnector(2, 2, pi/4);