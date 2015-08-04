function calCo = caliberate(s)
   out.s = s
   calCo.offset = 0 ;
   calCo.g = 1;
   
   % read the raw accelerometer output at three different orientations
   % gZ = 1, gX = gY = 0 orientation
   mbox = msgbox('Lay accel.m on a flat surface.', 'Caliberation');
   uiwait(mbox);
   [gx_z gy_z gz_z] = readAccel(out, calCo);
   
   % gX = 1, gY = gZ = 0 orientation
   mbox = msgbox('Stand accel.m so that X points up..', 'Caliberation');
   uiwait(mbox);
   [gx_x gy_x gz_x] = readAccel(out, calCo);
   
   % gY = 1, gX = gZ = 0 orientation
   mbox = msgbox('Stand accel.m so that Y points up..', 'Caliberation');
   uiwait(mbox);
   [gx_y gy_y gz_y] = readAccel(out, calCo);
   
   % calculate offsets for each axis
   offsetX = (gx_z + gx_y) / 2;
   offsetY = (gx_x + gx_z) / 2;
   offsetZ = (gx_x + gx_y) / 2;
   
   % calculate scaling factors
   gainX = gx_x - offsetX;
   gainY = gx_y - offsetY;
   gainZ = gz_z - offsetZ;
   
   calCo.offset = [offsetX offsetY offsetZ];
   calCo.g = [gainX gainY gainZ];
   
   mbox = msgbox('Sensor caliberation complete');
   uiwait(mbox);
   
end