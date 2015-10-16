%*-------------------------------------------------------------------------
%* (c) 2009 Microstrain, Inc.
%*-------------------------------------------------------------------------
%* THE PRESENT SOFTWARE WHICH IS FOR GUIDANCE ONLY AIMS AT PROVIDING 
%* CUSTOMERS WITH CODING INFORMATION REGARDING THEIR PRODUCTS IN ORDER 
%* FOR THEM TO SAVE TIME. AS A RESULT, MICROSTRAIN SHALL NOT BE HELD LIABLE 
%* FOR ANY DIRECT, INDIRECT OR CONSEQUENTIAL DAMAGES WITH RESPECT TO ANY 
%* CLAIMS ARISING FROM THE CONTENT OF SUCH SOFTWARE AND/OR THE USE MADE BY 
%* CUSTOMERS OF THE CODING INFORMATION CONTAINED HEREIN IN CONNECTION WITH 
%* THEIR PRODUCTS.
%*-------------------------------------------------------------------------
%*
%*-------------------------------------------------------------------------
%* Read Acceleration and Angular Rate
%*
%* This command link application demonstrates the general method for
%* retrieving data from the MicroStrain 3DM-GX3 sensors. The only input
%* needed from the user is the number of the serial port at which the
%* sensor is connected. The port number can be obtained via the Windows
%* Device Manager located at C:\WINDOWS\system32\devmgmt.msc. The device
%* will appear under "Ports (COM & LPT)" as either "CP210x USB to UART
%* Bridge Controller" or "MicroStrain Virtual COM Port." The function will
%* then return the Acceleration and Angular rate of the sensor, in x-, y-,
%* and z-components, and total magnitudes. Acceleration is measured in g's
%* (9.80665 m/s^2), and Angular Rate is measured in rad/s.
%*-------------------------------------------------------------------------

function [Error] = Read_Acceleration_And_Angular_Rate(SerialLink, Error, SampleRate, PortOpen)

% PROMPT02 = 'D - Get data for acceleration and angular rate\nQ - Quit';
% TITLE02 = 'Menu';
% 
% is_running = true;
Mode = 1;


% while is_running == true

%     while PortOpen == 1
%         %Get command from user
%         Input = char(inputdlg(PROMPT02, TITLE02, 1, {'D'}));
%         % Input = input('\nD - Get data for acceleration and angular rate\nQ - Quit\n\n','s');
%         
%         %If device is idling or sleeping, put into active mode
%         if Mode == 3 || Mode == 4 || Mode == 5
%             [Packet,Error] = i3dmgx3_SetReadMode(SerialLink,1);
%             if Error == 0
%                 Mode = 1;
%             end
%         end
%         %Execute command
%         if length(Input) == 1
%             if Input == 'D' || Input == 'd'
                %Get acceleration and angular rate, print in command window
%                 if Mode == 1
                    [Packet,Error] = i3dmgx3_AccelAndAngRate(SerialLink);
%                 elseif Mode == 2
%                     [Packet,Error] = i3dmgx3_AccelAndAngRateCM(SerialLink,SampleRate);
%                 end
                if Error == 0
                    i3dmgx3_PrintAccelAndAngRate(Packet);
                end
%             elseif Input == 'Q' || Input == 'q'
%                 %Terminate the function
%                 PortOpen = 0;
%                 is_running = false;
%             else
%                 fprintf('\nInvalid response\n');
%             end
%         else
%             fprintf('\nInvalid response\n');
%         end
        if Error ~= 0
            PortOpen = 0;
        end
%     end
%     closePort(ComNum);
    if Error ~= 0
        %Report error, ask user what to do next
        i3dmgx3_ExplainError(Error)
%         AskRestart = 1;
%         while AskRestart == 1
%             Input = input('\nP - Restart program\nQ - Quit\n\n','s');
%             if length(Input) == 1
%                 if Input == 'P' || Input == 'p'
%                     AskRestart = 0;
%                     is_running = true;
%                 elseif Input == 'Q' || Input == 'q'
%                     AskRestart = 0;
%                     is_running = false;
%                 else
%                     fprintf('\nInvalid response\n');
%                 end
%             else
%                 fprintf('\nInvalid response\n');
%             end
%         end
    end
% end
warning on MATLAB:serial:fread:unsuccessfulRead
