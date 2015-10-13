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

% Last Modified by GUIDE v2.5 12-Oct-2015 02:41:24

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
global GUI_COUNT_VALUE;
global KeepRunning;

GUI_COUNT_VALUE=0;
KeepRunning=1;
set(handles.pushbutton_start_imu,'Enable','on');
set(handles.pushbutton_pause_imu,'Enable','off');
set(handles.pushbutton_stop_imu,'Enable','off');

set(handles.pushbutton_start_gps,'Enable','on');
set(handles.pushbutton_pause_gps,'Enable','off');
set(handles.pushbutton_stop_gps,'Enable','off');

% Update handles structure
guidata(hObject, handles);

% *** load all libraries
load_folder_subfolder_libraries
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

global GUI_COUNT_VALUE;
global IS_IMU_Running;
IS_IMU_Running=true;

global IMU_SERIAL_PORT;
global SampleRate;
global IMU_OPEN_PORT;


% Start recieving data if stopeed before (not paused)
if GUI_COUNT_VALUE==0
    SampleRate = 1;
    [IMU_SERIAL_PORT, SampleRate, IMU_OPEN_PORT] =...
        setup_IMU(SampleRate);
end

if (IMU_OPEN_PORT)
    set(handles.pushbutton_start_imu,'Enable','off');
    set(handles.pushbutton_pause_imu,'Enable','on');
    set(handles.pushbutton_stop_imu,'Enable','on');
end

while (IS_IMU_Running && IMU_OPEN_PORT)
    GUI_COUNT_VALUE = GUI_COUNT_VALUE+1;
    set(handles.text1,'String',num2str(GUI_COUNT_VALUE));
    pause(0.0001);
    Read_Acceleration_And_Angular_Rate(IMU_SERIAL_PORT, SampleRate, IMU_OPEN_PORT);
end

% Close and delete the serial port, only if stopeed (not paused)
if GUI_COUNT_VALUE==0
    fclose(IMU_SERIAL_PORT);                                  % Close the serial port
    delete(IMU_SERIAL_PORT);                                  % Delete the serial object
end

% Update handles structure
guidata(hObject, handles);



% --- Executes on button press in pushbutton_start_gps.
function pushbutton_start_gps_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_start_gps (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global IS_GPS_Running;
IS_GPS_Running=1;
global GUI_COUNT_VALUE;
global GPS_SERIAL_PORT;
global GPS_Error;
global GPS_first_result;

% Start setting up the data recieving, if stopeed before (not paused)
if GUI_COUNT_VALUE==0
    [GPS_SERIAL_PORT, GPS_Error] = setup_gps;
end

if (GPS_Error ~= 0)
    set(handles.pushbutton_start_gps,'Enable','off');
    set(handles.pushbutton_pause_gps,'Enable','on');
    set(handles.pushbutton_stop_gps,'Enable','on');
end

while (IS_GPS_Running)
    % if this is the first result
    if (GUI_COUNT_VALUE == 0)
        [result_data_ENU, GPS_first_result, result_error] = GPS_new(GPS_SERIAL_PORT, true);
    else
        [result_data_ENU, ~, result_error] = GPS_new(GPS_SERIAL_PORT, false, GPS_first_result);
    end
    GUI_COUNT_VALUE=GUI_COUNT_VALUE+1;
    set(handles.text1,'String',num2str(GUI_COUNT_VALUE));
    % The pause is nec to not block the GUI!
    pause(0.0001);
end

% Close and delete the serial port, only if stopeed (not paused)
if GUI_COUNT_VALUE==0
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

% global GUI_COUNT_VALUE;
global IS_IMU_Running;
IS_IMU_Running=0;

set(handles.pushbutton_start_imu,'Enable','on');
set(handles.pushbutton_pause_imu,'Enable','off');
set(handles.pushbutton_stop_imu,'Enable','on');



% --- Executes on button press in pushbutton_pause_gps.
function pushbutton_pause_gps_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_pause_gps (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% global GUI_COUNT_VALUE;
global IS_GPS_Running;
IS_GPS_Running=0;

set(handles.pushbutton_start_gps,'Enable','on');
set(handles.pushbutton_pause_gps,'Enable','off');
set(handles.pushbutton_stop_gps,'Enable','on');



% --- Executes on button press in pushbutton_stop_imu.
function pushbutton_stop_imu_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_stop_gps (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global GUI_COUNT_VALUE;
global IS_IMU_Running;
GUI_COUNT_VALUE=0;
IS_IMU_Running=0;

set(handles.pushbutton_start_imu,'Enable','on');
set(handles.pushbutton_pause_imu,'Enable','off');
set(handles.pushbutton_stop_imu,'Enable','off');

set(handles.text1,'String','0');



% --- Executes on button press in pushbutton_stop_gps.
function pushbutton_stop_gps_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_stop_gps (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDqATA)

global GUI_COUNT_VALUE;
global IS_GPS_Running;
GUI_COUNT_VALUE=0;
IS_GPS_Running=0;

set(handles.pushbutton_start_gps,'Enable','on');
set(handles.pushbutton_pause_gps,'Enable','off');
set(handles.pushbutton_stop_gps,'Enable','off');

set(handles.text1,'String','0');



% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global IS_IMU_Running;
global IS_GPS_Running;
IS_IMU_Running=0;
IS_GPS_Running=0;
pause(1);

% Hint: delete(hObject) closes the figure
delete(hObject);
