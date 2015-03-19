function varargout = eeg(varargin)
% Last Modified by GUIDE v2.5 19-Mar-2015 19:14:33

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @eeg_OpeningFcn, ...
    'gui_OutputFcn',  @eeg_OutputFcn, ...
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


% --- Executes just before eeg is made visible.
function eeg_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to eeg (see VARARGIN)

% Choose default command line output for eeg
handles.output = hObject;

conn = {};
lib_lsl = lsl_loadlib();

handles.conn = conn;
handles.inlet = {};
handles.lib_lsl = lib_lsl;
handles.surf = plot(handles.sig_axes, [1:10]);
handles.data = op.data;
handles.musc = op.musiccntrl;


% Update handles structure
guidata(hObject, handles);
% UIWAIT makes eeg wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = eeg_OutputFcn(hObject, eventdata, handles)
varargout{1} = handles.output;


% --- Executes on button press in connect_B.
function connect_B_Callback(hObject, eventdata, handles)
[conn,inlet] = op.conn(handles.conn, handles.lib_lsl, 'EEG');
if (~ isempty(conn))
    handles.conn  = conn;
    handles.inlet = inlet;
    if (isempty(handles.inlet))
        disp('EMPTY INLET');
    end
    set(handles.conn_stat,'String','Connected');
end
guidata(hObject, handles);


function conn_stat_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function conn_stat_CreateFcn(hObject, eventdata, handles)
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in play_eeg_B.
function play_eeg_B_Callback(hObject, eventdata, handles)
if (~ isempty(handles.inlet))
    inlet = handles.inlet;
    handles.timer = timer(...
     'ExecutionMode', 'fixedRate', ...       % Run timer repeatedly
     'Period', 0.2, ...                        % Initial period is 1 sec.
      'TimerFcn', {@update_display,hObject}); % Specify callback function
    start(handles.timer);
    
end

guidata(hObject,handles);

% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
disp('bye');
timers = timerfind();
if length(timers) > 0
    stop(timers);
    delete(timers);
end
delete(hObject);


% --- Executes on button press in tcpcreate.
function tcpcreate_Callback(hObject, eventdata, handles)
handles.musc.restart();
if (handles.musc.connected())
    disp('tcp MUSIC connected');
    set(handles.musstat,'String','MUSIC Connected');
end
 
guidata(hObject,handles);

function update_display(hObject,eventdata,hfigure)
handles = guidata(hfigure);
inlet = handles.inlet;
if (~ isempty(inlet))
    [chunk,stamps] = op.recv( inlet ); % inlet.pull_chunk();
    d = chunk(1,:);
    handles.data.add(d);
    handles.musc.setNewVolume(handles.data.d);
    
    set(handles.surf,'YData',handles.data.d);
end
if (handles.musc.connected())
    set(handles.musstat,'String','MUSIC Connected');
else
    set(handles.musstat,'String','MUSIC NOT Connected');
end


function musstat_Callback(hObject, eventdata, handles)
% hObject    handle to musstat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of musstat as text
%        str2double(get(hObject,'String')) returns contents of musstat as a double


% --- Executes during object creation, after setting all properties.
function musstat_CreateFcn(hObject, eventdata, handles)
% hObject    handle to musstat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
