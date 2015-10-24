function i3dmgx3_PrintAccelAndAngRate(Packet)
%Prints acceleration and angular rate components and time
%
%Arguments: Packet - Data packet from sensor

Data = [convert2float32bin(Packet(2:5));        % accel
          convert2float32bin(Packet(6:9));
          convert2float32bin(Packet(10:13));
          convert2float32bin(Packet(14:17));    % angular rate
          convert2float32bin(Packet(18:21));
          convert2float32bin(Packet(22:25));
          convert2float32bin(Packet(26:29));    % orientation M11
          convert2float32bin(Packet(30:33));
          convert2float32bin(Packet(34:37));
          convert2float32bin(Packet(38:41));    % orientation M21
          convert2float32bin(Packet(42:45));
          convert2float32bin(Packet(46:49));
          convert2float32bin(Packet(50:53));    % orientation M31
          convert2float32bin(Packet(54:57));
          convert2float32bin(Packet(58:61));
          convert2ulong(Packet(62:65))/62500]; %Convert data to decimals
      
Data = [Data(1);    % accel
        Data(2);
        Data(3);
        norm(Data(1:3));
        Data(4);    % angular rate
        Data(5);
        Data(6);
        norm(Data(4:6));
        Data(7);    % orientation M11
        Data(8);
        Data(9);
        Data(10);    % orientation M21
        Data(11);
        Data(12);
        Data(13);    % orientation M31
        Data(14);
        Data(15);
        Data(16)];  % Date and time
    
PositivePrint = {sprintf('\nAcceleration:\nX:     %f g',Data(1));
                 sprintf('Y:     %f g',Data(2));
                 sprintf('Z:     %f g',Data(3));
                 sprintf('Total: %f g\n',Data(4));
                 sprintf('Angular Rate:\nX:     %f rad/s',Data(5));
                 sprintf('Y:     %f rad/s',Data(6));
                 sprintf('Z:     %f rad/s',Data(7));
                 sprintf('Total: %f rad/s\n',Data(8));
                 sprintf('Transformation Matrix:\nM11     %f',Data(9));
                 sprintf('M12     %f',Data(10));
                 sprintf('M13     %f',Data(11));
                 sprintf('M21     %f',Data(12));
                 sprintf('M22     %f',Data(13));
                 sprintf('M23     %f',Data(14));
                 sprintf('M31     %f',Data(15));
                 sprintf('M32     %f',Data(16));
                 sprintf('M33     %f',Data(17));
                 sprintf('Time: %f seconds from powerup',Data(18))}; %Define format to print data in
             
NegativePrint = {sprintf('\nAcceleration:\nX:    %f g',Data(1));
                 sprintf('Y:    %f g',Data(2));
                 sprintf('Z:    %f g',Data(3));
                 sprintf('Total:%f g\n',Data(4));
                 sprintf('Angular Rate:\nX:    %f rad/s',Data(5));
                 sprintf('Y:    %f rad/s',Data(6));
                 sprintf('Z:    %f rad/s',Data(7));
                 sprintf('Total:%f rad/s\n',Data(8));
                 sprintf('Transformation Matrix:\nM11    %f',Data(9));
                 sprintf('M12    %f',Data(10));
                 sprintf('M13    %f',Data(11));
                 sprintf('M21    %f',Data(12));
                 sprintf('M22    %f',Data(13));
                 sprintf('M23    %f',Data(14));
                 sprintf('M31    %f',Data(15));
                 sprintf('M32    %f',Data(16));
                 sprintf('M33    %f',Data(17));
                 sprintf('Time:%f seconds from powerup',Data(18))}; %Remove a space for negative values to make decimal points align
             
for DataNum = 1:numel(Data)
    if Data(DataNum) < 0
        disp(char(NegativePrint(DataNum))); %Print formatted data
    else
        disp(char(PositivePrint(DataNum)));
    end
end