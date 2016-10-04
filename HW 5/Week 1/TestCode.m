clear, close all, clc

%My notation is written so that 'gHB' is B in H's Frame. the '_l' denotes
%that the variable is associated with the Left Foot. I have it set up so
%that you can publish the script so that it is easier to see

a1 = pi; a2 = pi/2; a3 = pi/4;
b1 = pi/12; b2 = pi/2; b3 = pi/6;
gwk_l = SE2([9.4;0],a1); gwk_r = SE2([9.4;0],b1);  % Knee in Waist Frame
gka_l = SE2([12;0],a2); gka_r = SE2([12;0],b2);    % Ankle in Knee Frame
gaf_l = SE2([6;0],a3); gaf_r = SE2([6;0],b3);      % Foot in Ankle Frame
 
%% Waist Origin
%Left Foot in Waist Frame
gwa_l = mtimes(gwk_l,gka_l);  % Ankle in Waist Frame
disp('SE2 LF in W')
gwf_l = mtimes(gwa_l,gaf_l)  % Waist in Left Foot Frame

%Right Foot in Waist Frame
gwa_r = mtimes(gwk_r,gka_r);  % Ankle in Waist Frame
disp('SE2 RF in W')
gwf_r = mtimes(gwa_r,gaf_r)  % Waist in Right Foot Frame

%% Left Foot Origin
%Waist in Left Foot Frame
disp('SE2 W in LF')
gfw_l = inv(gwf_l)

%Right Foot in Left Foot Frame
disp('SE2 RF in LF')
gflr_r = inv(gaf_l) * gaf_r

%% Right Foot Origin
%Waist in Right Foot Frame
disp('SE2 W in RF')
gfw_r = inv(gwf_r)

%Left Foot in Right Foot Frame
disp('SE2 LF in RF')
gflr_l = inv(gflr_r)

%% Classdef
l = [pi, pi/2, pi/4];
r = [pi/12,pi/2,pi/6];
g = fk(l,r);
waist(g);
left(g);
right(g);