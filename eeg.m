function varargout = eeg(varargin)
% Last Modified by GUIDE v2.5 02-Apr-2015 15:16:50

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
handles.conn_raweeg = conn;
handles.inlet = {};
handles.inlet_raweeg = {};
handles.lib_lsl = lib_lsl;
handles.surf = plot(handles.sig_axes, [1:10]);
handles.surfraw = plot(handles.sig_raweeg, [1:10]);
handles.surfvol = plot(handles.sig_volume, ones(1,10) );
handles.data = op.data;
handles.musc = op.musiccntrl;
handles.avg_amp = 10;
handles.max_amp = 100;
handles.musc.setAmps(handles.avg_amp, handles.max_amp);
handles.musc.setPositiveFeedbacktype(false);

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
[conn_raweeg,inlet_raweeg] = op.conn(handles.conn, handles.lib_lsl, 'EEGsignal');

if (~ isempty(conn))
    handles.conn  = conn;
    handles.inlet = inlet;
    if (isempty(handles.inlet))
        disp('EMPTY INLET');
    end
    set(handles.conn_stat,'String','Connected');
end

if (~ isempty(conn_raweeg))
    handles.conn_raweeg  = conn_raweeg;
    handles.inlet_raweeg = inlet_raweeg;
    if (isempty(handles.inlet_raweeg))
        disp('EMPTY RAWEEG INLET');
    end
    set(handles.connraweeg_stat,'String','RAWEEG Connected');
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

%% MAIN TIMER FUNCTION
function update_display(hObject,eventdata,hfigure)
handles = guidata(hfigure);
inlet = handles.inlet;
d_power = [];
if (~ isempty(inlet))
    [chunk,stamps] = op.recv( inlet ); % inlet.pull_chunk();
    d_power = chunk(1,:);
    handles.data.add(d_power);
    %handles.musc.setNewVolume(handles.data.d);
    
    set(handles.surf,'YData',handles.data.d);
end

inlet_raweeg = handles.inlet_raweeg;
d_raw = [];
if (~ isempty(inlet_raweeg))
    [chunk,stamps] = op.recv( inlet_raweeg ); % inlet.pull_chunk();
    d_raw = chunk(1,:);
    handles.data.addRaw(d_raw);
        
    set(handles.surfraw,'YData',handles.data.draw);
end

if ((~ isempty(inlet)) && (~ isempty(inlet_raweeg)))
    volume = handles.musc.calcVolume(d_power, d_raw, handles.data.d, handles.data.draw);
    if (~ isnan(volume ))
         handles.data.addVol([volume]);
    end
    set(handles.surfvol,'YData',handles.data.dvol);
    %handles.musc.setNewVolume(handles.data.d);
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



function connraweeg_stat_Callback(hObject, eventdata, handles)
% hObject    handle to connraweeg_stat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of connraweeg_stat as text
%        str2double(get(hObject,'String')) returns contents of connraweeg_stat as a double


% --- Executes during object creation, after setting all properties.
function connraweeg_stat_CreateFcn(hObject, eventdata, handles)
% hObject    handle to connraweeg_stat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in calc_norma.
function calc_norma_Callback(hObject, eventdata, handles)
% hObject    handle to calc_norma (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
d_power = handles.data.d;
d_raw = handles.data.draw;

d_avgAmp = mean( abs ( d_raw - mean(d_raw)) );
d_maxAmp = sort( abs ( d_raw - mean(d_raw)) );
d_maxAmp = mean( d_maxAmp(end-5:end) );

set(handles.edit_avgamp, 'String', d_avgAmp);
set(handles.edit_maxamp, 'String', d_maxAmp);


function edit_avgamp_Callback(hObject, eventdata, handles)
% hObject    handle to edit_avgamp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_avgamp as text
%        str2double(get(hObject,'String')) returns contents of edit_avgamp as a double


% --- Executes during object creation, after setting all properties.
function edit_avgamp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_avgamp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_maxamp_Callback(hObject, eventdata, handles)
% hObject    handle to edit_maxamp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_maxamp as text
%        str2double(get(hObject,'String')) returns contents of edit_maxamp as a double


% --- Executes during object creation, after setting all properties.
function edit_maxamp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_maxamp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in b_acceptNewNorma.
function b_acceptNewNorma_Callback(hObject, eventdata, handles)
% hObject    handle to b_acceptNewNorma (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.avg_amp = str2double( get(handles.edit_avgamp, 'String'));
handles.max_amp = str2double( get(handles.edit_maxamp, 'String'));

handles.musc.lasNumPower = str2double( get(handles.edit_npower, 'String'));
handles.musc.setAmps(handles.avg_amp, handles.max_amp);

guidata(hObject,handles);


% --- Executes on button press in btn_restartvol.
function btn_restartvol_Callback(hObject, eventdata, handles)
% hObject    handle to btn_restartvol (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.musc.restart_data();
handles.data.dvol = [];


% --- Executes on button press in check_biotype.
function check_biotype_Callback(hObject, eventdata, handles)
% hObject    handle to check_biotype (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of check_biotype
value = get(hObject,'Value');
if (value == 0)
    handles.musc.setPositiveFeedbacktype(true);
elseif (value == 1)
    handles.musc.setPositiveFeedbacktype(false);
end



function edit_npower_Callback(hObject, eventdata, handles)
% hObject    handle to edit_npower (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_npower as text
%        str2double(get(hObject,'String')) returns contents of edit_npower as a double


% --- Executes during object creation, after setting all properties.
function edit_npower_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_npower (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
