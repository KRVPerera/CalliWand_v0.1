clc;
close all;
clear all;

%% comPort
comPort = '/dev/ttyACM0'

if(~exist('serialFlag', 'var'))
   [gyroConnection.s, serialFlag] = setupSerial(comPort); 
end

%% Figure GUI creation

%If figure does not exist, create one
if(~exist('figureHandle', 'var') || ~isHandle(figureHandle))
   figureHandle = figure(1); 
end

% Create the stop button
if(~exist('stopButton', 'var'))
    stopButton = uicontrol('Style', 'togglebutton', 'String', ...
        'Stop & Close Serial Port', ...
        'pos', [0 0 200 25], 'parent', figureHandle);
end

% Create the axis selectors
if(~exist('axisSwitchX', 'var'))
   axisSwitchX = uicontrol('Style','checkbox', 'String', 'X axis',...
       'pos', [300 0 50 25], 'parent', figureHandle);
end

if(~exist('axisSwitchY', 'var'))
   axisSwitchY = uicontrol('Style','checkbox', 'String', 'Y axis',...
       'pos', [350 0 50 25], 'parent', figureHandle);
end

if(~exist('axisSwitchZ', 'var'))
   axisSwitchZ = uicontrol('Style','checkbox', 'String', 'Z axis',...
       'pos', [400 0 50 25], 'parent', figureHandle);
end

% Create the angle labels
if(~exist('degreeLabelX', 'var'))
   degreeLabelX = uicontrol('Style', 'text', 'String', 'X: 0 degrees', ...
       'pos', [450 100 150 30], 'parent', figureHandle);
end

if(~exist('degreeLabelY', 'var'))
    degreeLabelY = uicontrol('Style', 'text', 'String', 'Y: 0 degrees',...
        'pos', [450 75 150 30], 'parent', figureHandle);
end

if(~exist('degreeLabelZ', 'var'))
    degreeLabelZ = uicontrol('Style', 'text', 'String', 'Z: 0 degrees',...
        'pos', [450 50 150 30], 'parent', figureHandle);
end

% Create the display angle reset button
if(~exist('resetRadioButton','var'))
   resetRadioButton = uicontrol('Style', 'radiobutton' ,'String', 'Reset', ...
       'pos', [500 0 100 30], 'parent', figureHandle);
end

%% Visualization

% Setup graph axes
graphAxes = axes('XLim', [-2 2], 'YLim', [-2 2], 'ZLim', [-2 2]);
% Turn view to 3D
view(3);
% Turn axis markers off and axis to equal
axis off;
axis equal;

% Create a cylinder
[cylX, cylY, cylZ] = cylinder(0.1);

% Create a cone
[conX, conY, conZ] = cylinder([0.1,0]);

% Add the cylinder to the hgtransform array
hgTransformArray(1) = surface(cylX, cylY, cylZ);
% Add the cone to the hgtransform array
hgTransformArray(2) = surface(conX, conY, conZ+1);

% Create the hgtransform
hgTransform = hgtransform('Parent', graphAxes);

% Add the hgtransform object to the graph
set(hgTransformArray, 'Parent', hgTransform);
drawnow();
pause(0.25);

%% Calibrate the gyro
% [ gainx, gainy, gainz ] = calibrateGyro(gyroConnection);
gainx = -5;
gainy = -5;
gainz = -5;

%% Visualization loop

% Variables to store the display angles
displayAngleX = 0;
displayAngleY = 0;
displayAngleZ = 0;

% Variable to store the actual angles
angleX = 0;
angleY = 0;
angleZ = 0;

% While stop button has not been pushed
while( get(stopButton, 'Value') == 0)
   % Get the new angles
   [ newAngleX, newAngleY, newAngleZ ] = ...
       getAngles(gyroConnection, gainx, gainy, gainz);
   
   % If the X switch is on
   if get(axisSwitchX, 'Value') == 1
      % Get the change in angle from the pevious run
      deltaAngleX = angleX - newAngleX;
      
      % Calculate the new display angle
      displayAngleX = displayAngleX + deltaAngleX;
      
      % Save the actual angle
      angleX = newAngleX;
      
      % Update the display text
      set(degreeLabelX, 'String', ['X: ' num2str(round(displayAngleX)) ' degrees']);
   end
   
   % If the Y switch is on
   if get(axisSwitchY, 'Value') == 1
       % Get the change in angle from the previous run
       deltaAngleY = angleY - newAngleY;
       
       % Calculate the new display angle
       displayAngleY = displayAngleY + deltaAngleY;
       
       % Save the actual angle
       angleY = newAngleY;
       
       % Update the display text
       set(degreeLabelY, 'String', ['Y : ' num2str(round(displayAngleY)) ' degrees']);
   end
   
   % If the Z switch is on
   if get(axisSwitchZ, 'Value') == 1
       % Get the change in angle from the previous run
       deltaAngleZ = angleZ- newAngleZ;
       
       % Calculate the new display angle
       displayAngleZ = displayAngleZ + deltaAngleZ;
       
       % Save the actual angle
       angleZ = newAngleZ;
       
       % Update the display text
       set(degreeLabelZ, 'String', ['Z : ' num2str(round(displayAngleZ)) ' degrees']);
   end
   
   % Form rotation matrix
   R = makehgtform('xrotate', (round(displayAngleX)*pi/180), ...
       'yrotate', (round(displayAngleY)*pi/180), ...
       'zrotate', (round(displayAngleZ)*pi/180));
   
   % Set transform
   set(hgTransform, 'Matrix', R);
   
   % If reset button is pressed then
   if (get(resetRadioButton, 'Value') == 1)
       % Reset the display angles
       displayAngleX = 0;
       displayAngleY = 0;
       displayAngleZ = 0;
       
       % Reset the radio button to not selected
       set(resetRadioButton, 'Value', 0);
   end
   
   drawnow;
end

closeSerial();