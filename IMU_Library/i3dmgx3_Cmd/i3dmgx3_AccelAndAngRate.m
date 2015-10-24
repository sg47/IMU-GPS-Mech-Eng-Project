function [Packet,Error] = i3dmgx3_AccelAndAngRate(SerialLink)
%Reads scaled Acceleration and Angular Rate from sensor
%
%Arguments: SerialLink - Handle of serial link
%
%Returns:   Packet - The data packet
%           Error - Error number

ACC_COMMAND = 'CMD_ACCELERATION_ANGU';
% ANG_COMMAND = 'CMD_ACCELERATION_ANGU';
% ORI_COMMAND = 'CMD_ORRIENTATION_MAT';
% ACC_ANG_MAG_ORI_COMMAND = 'CMD_ACCEL_ANG_MAG_VECTO';


Error = purgePort(SerialLink); %Clear buffer
if Error == 0
    Error = i3dmgx3_SendBuffData(SerialLink,ACC_COMMAND); %Write command to device
    if Error == 0
        [Packet,Error] = i3dmgx3_ReceiveData(SerialLink,ACC_COMMAND); %Read data from device
        if Error ~= 0
            Packet = [];
        end
    else
        Packet = [];
    end
else
    Packet = [];
end