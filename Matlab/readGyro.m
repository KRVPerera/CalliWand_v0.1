function [gx, gy, gz] = readGyro(gyroConnection, isCaliberation)

    % If not caliberating, send request for sensor values
    if(~isCaliberation)
        fprintf(gyroConnection.s, 'G');
    end
    
    % map analog inputs to axes
    gx = fscanf(gyroConnection.s, '%d');
    gy = fscanf(gyroConnection.s, '%d');
    gz = fscanf(gyroConnection.s, '%d');
end
