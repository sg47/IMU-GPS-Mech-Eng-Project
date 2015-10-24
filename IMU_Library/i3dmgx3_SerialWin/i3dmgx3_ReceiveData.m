function [RawPacket,Error] = i3dmgx3_ReceiveData(SerialLink,Command)
%Receives data from sensor
%
%Arguments: SerialLink - Handle of serial link
%           Command - A string from the command array in i3dmgx3_Cmd.m
%
%Returns:   Packet - Data packet, if successfully read (empty matrix if not)
%           Error - Error number

CommandArray = i3dmgx3_Cmd; %Call command array
CommandNum = strmatch(Command,CommandArray(:,1)); %Find command
CommandBytes = CommandArray{CommandNum,2}; %Find command bytes
ResponseLength = CommandArray{CommandNum,4}; %Find number of command bytes
RawPacket = fread(SerialLink,ResponseLength); %Read data packet from device
if isempty(RawPacket) == 0 %Check for response
    if length(RawPacket) == ResponseLength; %Check response length
        if RawPacket(1) == CommandBytes(1) %Check for proper command byte
            if i3dmgx3_CalcChecksum(RawPacket) == i3dmgx3_Checksum(RawPacket) %Evaluate checksum
                Error = 0; %No error
            else
                Error = 8; %Incorrect checksum
            end
        else
            Error = 5; %Output does not match command
        end
    else
        Error = 5; %Output does not match command
    end
else
    Error = 6; %Could not read device
end