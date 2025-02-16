function [Packet,Error] = i3dmgx3_ContinuousPresetCM(SerialLink,Command,SampleRate)
%Sets or reads the data type that the sensor will output in continous mode
%
%Arguments: SerialLink - Handle of serial link
%           Command - Command for data type to output in continuous mode
%           SampleRate - Rate at which device sends out packets
%
%Returns:   Packet - The data packet
%           Error - Error number

Error = purgePort(SerialLink); %Clear buffer
if Error == 0
    Error = i3dmgx3_SendBuffData(SerialLink,'CMD_CONTINUOUS_PRESET'); %Write command to device
    if Error == 0
        Error = i3dmgx3_SendBuffData(SerialLink,Command); %Write data type to device
        if Error == 0
            [Packet,Record,Error] = i3dmgx3_ReceiveDataContinuous(SerialLink,'CMD_CONTINUOUS_PRESET',SampleRate); %Read data from device
            if Error ~= 0
                Packet = [];
            end
        else
            Packet = [];
        end
    else
        Packet = [];
    end
else
    Packet = [];
end