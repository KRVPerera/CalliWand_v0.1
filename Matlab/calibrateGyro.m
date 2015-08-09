function [gainx, gainy, gainz] = calibrateGyro(gyroConnection)
   mbox = msgbox('Begin Calibration. Align the x axis for calibration.');
   uiwait(mbox);
   gainx = calibrateAxis(gyroConnection, 'x');
   
   mbox = msgbox('Calibration for y axis complete. Align the y axis for calibration.');
   uiwait(mbox);
   gainy = calibrationAxis(gyroConnection, 'y');
   
   mbox = msgbox('Calibration for z axis complete. Align the y axis for calibration.');
   uiwait(mbox);
   gainy = calibrationAxis(gyroConnection, 'z');
   
   mbox = msgbox('Calibration complete');
   uiwait(mbox);
   
   disp('Calibration Done');
   
    function gainAverage = calibrateAxis(gyro, axis)
        gainAverage = 0;
        
        for j=1:5
            tic;
            
            % init variables
            prevTime = 0;
            prevRate = 0;
            angle = 0;
            
            fprintf(gyro.s, 'C');
            for i=1:50
                [ratex, ratey, ratez] = readGyro(gyro, true);
                if (axis == 'x'); rate = ratex; end
                if (axis == 'y'); rate = ratey; end
                if (axis == 'z'); rate = ratez; end
                
                currentTime=toc;
                
                newAngle = ((prevRate/2 + rate/2) *...
                    (currentTime - prevTime)*1)/100);
                
                angle = angle + newAngle;
                
                prevRate = rate;
                prevTime = currentTime;
            end
            %calculate gain constant
            gain = 180/angle;
            
            % add the gain constant to the average and pause
            gainAverage = gainAverage + gain;
            pause(1);            
        end
        gainAverage = (gainAverage/5);
    end
   
end