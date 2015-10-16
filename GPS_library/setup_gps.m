function [gps_serial_port, Error] = setup_gps

PROMPT01 = 'Please enter COM port # (1 for COM1, etc.): ';
% PROMPT02 = 'D - Get data for acceleration and angular rate\nQ - Quit';
TITLE01 = 'COM port';
Error = false;

gps_serial_port = '';
ComNum = char(inputdlg(PROMPT01, TITLE01, 1, {'2'}));

if isstrprop(ComNum,'digit')
%     ComNum = str2double(ComNum);
    % Create a serial port object.
    gps_serial_port = instrfind('Type', 'serial', 'Port', strcat('COM', ComNum), 'Tag', '');


    % Create the serial port object if it does not exist 
    % otherwise use the object that was found.
    if isempty(gps_serial_port)
        gps_serial_port = serial(strcat('COM', ComNum));     % Create serial object (PORT Dependent)
    else
        fclose(gps_serial_port);
        gps_serial_port = gps_serial_port(1);
    end

    gps_serial_port.InputBufferSize = 256; %number of bytes in inout buffer
    % s.FlowControl = hardware;
    gps_serial_port.BaudRate = 9600;
    % s.Parity = none;
    gps_serial_port.DataBits = 8;
    gps_serial_port.StopBit = 1;
    gps_serial_port.Timeout = 5;
    gps_serial_port.Parity = 'none';
    gps_serial_port.StopBits = 1;
    gps_serial_port.BytesAvailableFcnMode = 'terminator';
    gps_serial_port.Terminator = 'CR/LF';


    % Connect to instrument object, s. Open the serial port for r/w
    fopen(gps_serial_port);
else
    fprintf('\nInvalid COM selected\n');
    h = msgbox('Invalid COM selected.');
    Error = true;
end


