 function [ angleX, angleY, angleZ ] = getAngles( gyroConnection, gainx, gainy, gainz )

persistent previousRateX;
persistent previousRateY;
persistent previousRateZ;
if(isempty(previousRateX)); previousRateX = 0; end
if(isempty(previousRateY)); previousRateY = 0; end
if(isempty(previousRateZ)); previousRateZ = 0; end

persistent previousAngleX;
persistent previousAngleY;
persistent previousAngleZ;
if(isempty(previousAngleX)); previousAngleX = 0; end
if(isempty(previousAngleY)); previousAngleY = 0; end
if(isempty(previousAngleZ)); previousAngleZ = 0; end

persistent previousTime;
if(isempty(previousTime)); previousTime = 0; tic; end

%% new angles
[rateX, rateY, rateZ] = readGyro(gyroConnection, false);
currentTime = toc;

%% calculate x
% angular rate in X axis
newAngleX = calculateAngle(previousRateX, rateX, gainx);

% update the angle x
angleX = updateAngle(previousAngleX + newAngleX);

%% calculate Y
% Angular rate in Y axis
newAngleY = calculateAngle(previousRateY, rateY, gainy);

% update the angle y
angleY = updateAngle(previousAngleY + newAngleY);

%% calculate Z
% Angular rate in Z axis
newAngleZ = calculateAngle(previousRateZ, rateZ, gainz);

% update the angle y
angleZ = updateAngle(previousAngleZ + newAngleZ);

%% store previous values
previousRateX = rateX;
previousRateY = rateY;
previousRateZ = rateZ;
previousAngleX = angleX;
previousAngleY = angleY;
previousAngleZ = angleZ;
previousTime = currentTime;

%% Inner Functions
     function [angle] = calculateAngle(previousRate, rate, gain)
         % Delta angle = averaged angular velocity * delta time * gain
         angle = ((previousRate/2 + rate/2) * ...
             (currentTime - previousTime)*gain)/(100);
     end
 
     function [angle] = updateAngle(angle)
         if (angle<0)
             angle = angle + 360;
         else if (angle >= 360)
                 angle = angle - 360;
             end
         end
     end
end

