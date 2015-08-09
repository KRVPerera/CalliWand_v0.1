function [ax ay az] = readAccel(out, calCo)
    % send a character to read data
    fprintf(out.s, 'R');

    % read values from accelerometer
    readings(1) = fscanf(out.s, '%u');
    readings(2) = fscanf(out.s, '%u');
    readings(3) = fscanf(out.s, '%u');

    % determine
    offset = calCo.offset;
    gain = calCo.g;
    accel = (readings - offset) ./gain;

    % map analog inputs to axis
    ax = accel(1);
    ay = accel(2);
    az = accel(3);
end
