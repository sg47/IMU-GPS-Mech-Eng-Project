%  SerialComm.m  Scott McLeod, Sandeep Prabhu, Brett Pihl 2/4/2008
%  This program is designed to communicate to a PIC 18F4520 via RS232 (Serial) Communication.
%  
%  The main loop of this program waits for a character input from the user,
%  upon which it transmits the ascii value and waits for data to be written.
function [result_data_ENU, result_error, result_data] = gps_read(gps_serial_port, is_first, result_data_first)
PROMPT01 = 'A timeout occurred. Are you sure the GPS device is connected or the correct port was selected?';



% TODO: check when empty, 

data='';
result_data_ENU='';
result_data='';

% We only want the strings with $GPGLL…
if isempty(strmatch('$GPGLL',data))
    try
        data = fscanf(gps_serial_port);
        % TODO: add a timer for timeout?
        fprintf(data);          % Read Data back from PIC
        [result_data, result_error] = nmealineread(data);
        if (result_error ~= -1)
            if (is_first)
                result_data_ENU = convert2enu(result_data, result_data)
            else
                result_data_ENU = convert2enu(result_data, result_data_first)
            end
        end
    catch
        h = msgbox(PROMPT01);
        result_error = true;
    end
end

