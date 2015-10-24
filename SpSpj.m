function varargout = SpSpj(varargin)
%example of using buttons to start and stop events created by Paulo Silva
%SPSPJ M-file for SpSpj.fig
%      SPSPJ, by itself, creates a new SPSPJ or raises the existing
%      singleton*.
%
%      H = SPSPJ returns the handle to a new SPSPJ or the handle to
%      the existing singleton*.
%
%      SPSPJ('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SPSPJ.M with the given input arguments.
%
%      SPSPJ('Property','Value',...) creates a new SPSPJ or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before SpSpj_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to SpSpj_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help SpSpj

% Last Modified by GUIDE v2.5 23-Oct-2015 16:26:06

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @SpSpj_OpeningFcn, ...
                   'gui_OutputFcn',  @SpSpj_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before SpSpj is made visible.
function SpSpj_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to SpSpj (see VARARGIN)

% Choose default command line output for SpSpj
handles.output = hObject;
global IS_IMU_PAUSED;
global IS_GPS_PAUSED;
% global KeepRunning;
global IMU_SAMPLE_RATE;

IS_IMU_PAUSED = false;
IS_GPS_PAUSED = false;
IMU_SAMPLE_RATE = 50;
% KeepRunning=1;

set(handles.pushbutton_start_imu,'Enable','on');
set(handles.pushbutton_pause_imu,'Enable','off');
set(handles.pushbutton_stop_imu,'Enable','off');

set(handles.pushbutton_start_gps,'Enable','on');
set(handles.pushbutton_pause_gps,'Enable','off');
set(handles.pushbutton_stop_gps,'Enable','off');

% Update handles structure
guidata(hObject, handles);

% *** load all libraries
load_folder_subfolder_libraries;
% UIWAIT makes SpSpj wait for user response (see UIRESUME)
% uiwait(handles.figure1);



% --- Outputs from this function are returned to the command line.
function varargout = SpSpj_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



% --- Executes on button press in pushbutton start.
function pushbutton_start_imu_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_start_imu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%start

global IS_IMU_PAUSED;
global IS_IMU_RUNNING;
global IMU_SERIAL_PORT;
global IMU_SAMPLE_RATE;
global IMU_OPEN_PORT;
IS_IMU_RUNNING = true;


global IS_GPS_RUNNING;
global IS_GPS_PAUSED;
global GPS_SERIAL_PORT;
global GPS_Error;
global GPS_FIRST_RESULT;
IS_GPS_RUNNING = true;




% Start recieving data if stopeed before (not paused)
if ~IS_IMU_PAUSED
    [IMU_SERIAL_PORT, IMU_SAMPLE_RATE, IMU_OPEN_PORT] =...
        setup_IMU(IMU_SAMPLE_RATE);
end

% Start setting up the data recieving, if stopeed before (not paused)
% Also the GPS should not have been paused before.
if ~IS_GPS_PAUSED
    [GPS_SERIAL_PORT, GPS_Error] = setup_gps;
end




if (IMU_OPEN_PORT)
    set(handles.pushbutton_start_imu,'Enable','off');
    set(handles.pushbutton_pause_imu,'Enable','on');
    set(handles.pushbutton_stop_imu,'Enable','on');
end

if (~GPS_Error)
    result_error = false;
    % This is the first result for GPS, the local ENU is based on this.
    if ~IS_GPS_PAUSED
        [result_data_ENU, result_error, GPS_FIRST_RESULT] = ...
                gps_read(GPS_SERIAL_PORT, true);
    end
    % Set up GUI
    if ~result_error
        set(handles.pushbutton_start_gps,'Enable','off');
        set(handles.pushbutton_pause_gps,'Enable','on');
        set(handles.pushbutton_stop_gps,'Enable','on');
    else
        GPS_Error = true;
    end
end



while (~GPS_Error && IS_GPS_RUNNING && IS_IMU_RUNNING && IMU_OPEN_PORT)
    [result_data_ENU, result_error] = read_gps_and_display(GPS_SERIAL_PORT, false, GPS_FIRST_RESULT);
%     end
%     GUI_COUNT_VALUE=GUI_COUNT_VALUE+1;
%     set(handles.text1,'String',num2str(GUI_COUNT_VALUE));
    % The pause is nec to not block the GUI!
    pause(0.0001);
    
    % Set(handles.text1,'String',num2str(IS_IMU_PUASED));
    read_imu_packet_and_display(IMU_SERIAL_PORT, IMU_SAMPLE_RATE, IMU_OPEN_PORT);
    pause(0.0001);
end





% while (IS_IMU_RUNNING && IMU_OPEN_PORT)
%     % Set(handles.text1,'String',num2str(IS_IMU_PUASED));
%     read_imu_packet_and_display(IMU_SERIAL_PORT, IMU_SAMPLE_RATE, IMU_OPEN_PORT);
%     pause(0.0001);
% end

% Closes and deletes the serial port, only if stopeed (not paused)
if (IMU_OPEN_PORT && ~IS_IMU_PAUSED)
    fclose(IMU_SERIAL_PORT);                                  % Close the serial port
    delete(IMU_SERIAL_PORT);                                  % Delete the serial object
end

% Close and delete the serial port, only if stopeed (not paused)
if (~GPS_Error && ~IS_GPS_PAUSED)
    fclose(GPS_SERIAL_PORT);                                  % Close the serial port
    delete(GPS_SERIAL_PORT);                                  % Delete the serial object
end

% Update handles structure
guidata(hObject, handles);



% --- Executes on button press in pushbutton_start_gps.
function pushbutton_start_gps_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_start_gps (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global IS_GPS_RUNNING;
global IS_GPS_PAUSED;
global GPS_SERIAL_PORT;
global GPS_Error;
global GPS_FIRST_RESULT;

IS_GPS_RUNNING = true;

% Start setting up the data recieving, if stopeed before (not paused)
% Also the GPS should not have been paused before.
if ~IS_GPS_PAUSED
    [GPS_SERIAL_PORT, GPS_Error] = setup_gps;
end

if (~GPS_Error)
    result_error = false;
    % This is the first result for GPS, the local ENU is based on this.
    if ~IS_GPS_PAUSED
        [result_data_ENU, result_error, GPS_FIRST_RESULT] = ...
                read_gps_and_display(GPS_SERIAL_PORT, true);
    end
    % Set up GUI
    if ~result_error
        set(handles.pushbutton_start_gps,'Enable','off');
        set(handles.pushbutton_pause_gps,'Enable','on');
        set(handles.pushbutton_stop_gps,'Enable','on');
    else
        GPS_Error = true;
    end
end

while (~GPS_Error && IS_GPS_RUNNING)
    [result_data_ENU, result_error] = read_gps_and_display(GPS_SERIAL_PORT, false, GPS_FIRST_RESULT);
%     end
%     GUI_COUNT_VALUE=GUI_COUNT_VALUE+1;
%     set(handles.text1,'String',num2str(GUI_COUNT_VALUE));
    % The pause is nec to not block the GUI!
    pause(0.0001);
end

% Close and delete the serial port, only if stopeed (not paused)
if (~GPS_Error && ~IS_GPS_PAUSED)
    fclose(GPS_SERIAL_PORT);                                  % Close the serial port
    delete(GPS_SERIAL_PORT);                                  % Delete the serial object
end

% Update handles structure
guidata(hObject, handles);



% --- Executes on button press in pushbutton_pause_imu.
function pushbutton_pause_imu_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_pause_imu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% IMU
global IS_IMU_RUNNING;
global IS_IMU_PAUSED;
IS_IMU_RUNNING = false;
IS_IMU_PAUSED = true;


% GPS
global IS_GPS_RUNNING;
global IS_GPS_PAUSED;
IS_GPS_RUNNING = false;
IS_GPS_PAUSED = true;

set(handles.pushbutton_start_imu,'Enable','on');
set(handles.pushbutton_pause_imu,'Enable','off');
set(handles.pushbutton_stop_imu,'Enable','on');



% --- Executes on button press in pushbutton_pause_gps.
function pushbutton_pause_gps_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_pause_gps (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% global GUI_COUNT_VALUE;
global IS_GPS_RUNNING;
global IS_GPS_PAUSED;
IS_GPS_RUNNING = false;
IS_GPS_PAUSED = true;

set(handles.pushbutton_start_gps,'Enable','on');
set(handles.pushbutton_pause_gps,'Enable','off');
set(handles.pushbutton_stop_gps,'Enable','on');



% --- Executes on button press in pushbutton_stop_imu.
function pushbutton_stop_imu_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_stop_gps (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global IS_IMU_PAUSED;
global IS_IMU_RUNNING;
IS_IMU_PAUSED = false;
IS_IMU_RUNNING = false;


global IS_GPS_PAUSED;
global IS_GPS_RUNNING;
IS_GPS_PAUSED = false;
IS_GPS_RUNNING = false;

set(handles.pushbutton_start_imu,'Enable','on');
set(handles.pushbutton_pause_imu,'Enable','off');
set(handles.pushbutton_stop_imu,'Enable','off');

set(handles.text1,'String','0');



% --- Executes on button press in pushbutton_stop_gps.
function pushbutton_stop_gps_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_stop_gps (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDqATA)

global IS_GPS_PAUSED;
global IS_GPS_RUNNING;
IS_GPS_PAUSED = false;
IS_GPS_RUNNING = false;

set(handles.pushbutton_start_gps,'Enable','on');
set(handles.pushbutton_pause_gps,'Enable','off');
set(handles.pushbutton_stop_gps,'Enable','off');

set(handles.text1,'String','0');



% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global IS_IMU_RUNNING;
global IS_GPS_RUNNING;
IS_IMU_RUNNING = false;
IS_GPS_RUNNING = false;
pause(1);

% Hint: delete(hObject) closes the figure
delete(hObject);



function edit_imu_sample_rate_Callback(hObject, eventdata, handles)
% hObject    handle to edit_imu_sample_rate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global IMU_SAMPLE_RATE;

edit_txt_content = get(hObject,'String');
if isstrprop(edit_txt_content,'digit')
    sample_rate = round(str2double(edit_txt_content));
    if (sample_rate > 0 && sample_rate < 251)
        IMU_SAMPLE_RATE = sample_rate;
        set(hObject,'String',IMU_SAMPLE_RATE);
    else
        h = msgbox('The desired sampling rate should be between 1 and 250 Hz.');
        set(hObject,'String','50');
    end
else
    h = msgbox('The desired sampling rate should be a positive integer.');
    set(hObject,'String','50');
end
% Hints: get(hObject,'String') returns contents of edit_imu_sample_rate as text
%        str2double(get(hObject,'String')) returns contents of edit_imu_sample_rate as a double


% --- Executes during object creation, after setting all properties.
function edit_imu_sample_rate_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_imu_sample_rate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

set(hObject,'String','50');
