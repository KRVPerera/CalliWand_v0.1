clc;
close all;
clear all;

%% comPort selection
comPort = '/dev/ttyACM0'

if(~exist('serialFlag', 'var'))
    [gyroConnection.s, serialFlag] = setupSerial(comPort);
end

%% Calibrate Gyro
%[gainx, gainy, gainz ] = calibrateGyro(gyroConnection);
gainx = 1;
gainy = 1;
gainz = 1;

%% Read gyro values from embedded system
% open a figure with a buttom to break the while loop

h = uicontrol('Style', 'PushButton', 'String', 'Stop', ...
    'Callback', 'delete(gcbo)');

while ishandle(h)
    [ anglex, angley, anglez ] = ...
        getAngles(gyroConnection, gainx, gainy, gainz);
    fprintf('X: %f Y: %f Z: %f\n', anglex, angley, anglez);
    
    pause(0.01);
end

closeSerial();