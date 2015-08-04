function [s, flag] = setupSerial(comPort)
% initialize a serial communication with a device via com ports
% Predefined code on the device acknowledges this.
% if setup is complete then the value of setup is 
% returned as 1 else as 0
flag = 1;

s = serial(comPort);
set(s, 'DataBits', 8);
set(s, 'StopBits', 1);
set(s, 'BaudRate', 38400);
set(s, 'Parity', 'none');
fopen(s);
a='b';
while (a ~= 'a')
    a=fread(s, 1, 'uchar');
end
if (a == 'a')
    disp('serial read okay');
end
fprintf(s, '%c', 'a');
mbox = msgbox('Serial Communication setup. '); uiwait(mbox);
%fscanf(s, '%u');
%fclose(s);
end

