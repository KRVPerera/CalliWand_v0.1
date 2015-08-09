%% comport
comPort = '/dev/ttyACM0'

%% setup serial
if (~exist('serialFlag', 'var'))
    [accelerometer.s, serialFalg] = setupSerial(comPort);
end

%% Run caliberation routine
% if not caliberated
if(~exist('calCo', 'var'))
    calCo = caliberate(accelerometer.s);
end

%% open a new figure
if( ~exist('h', 'var') || ~ishandle(h))
    h = figure(1);
    ax = axes('box', 'on');
end

if(~exist('button', 'var'))
    button = uicontrol('Style', 'pushbutton', 'String', 'Stop',...
        'pos',[0 0 50 25], 'parent',h,...
        'Callback', 'stop_call_magnitude', 'UserData',1);
end

if(~exist('button2', 'var'))
    button2 = uicontrol('Style', 'pushbutton', 'String', 'Close Serial Port',...
        'pos',[250 0 150 25], 'parent',h,...
        'Callback', 'closeSerial', 'UserData',1);
end

% initialize the plot
buf_len = 100;
index = 1:buf_len;

% create variables for the X axis
gxdata = zeros(buf_len, 1);
gydata = zeros(buf_len, 1);
gzdata = zeros(buf_len, 1);

while(get(button, 'UserData'))
    % get values from the accelerometer
    [gx gy gz] = readAccel(accelerometer, calCo);
    
    % update rolling plot, append new data to end
    % of the rolling plot data
    gxdata = [gxdata(2:end) ; gx];
    gydata = [gydata(2:end) ; gy];
    gzdata = [gzdata(2:end) ; gz];
    
    %plot for X
    plot(index,gxdata, 'r', index,gydata, 'g', index , gzdata, 'b');
    
    axis([1 buf_len -2 2]);
    xlabel('time');
    ylabel('Magnitude of X axis acceleration');
    
    drawnow;
    
end

 
