function varargout = lpc_code(varargin)
% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @guilab_OpeningFcn, ...
                   'gui_OutputFcn',  @guilab_OutputFcn, ...
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
% --- Executes just before guilab is made visible.
function guilab_OpeningFcn(hObject, eventdata, handles, varargin)
% Choose default command line output for guilab
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
% --- Outputs from this function are returned to the command line.
function varargout = guilab_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% Get default command line output from handles structure
varargout{1} = handles.output;

%******************************************************
% --- Executes on selection change in window.
%Window dropdown menu
function window_Callback(hObject, eventdata, handles)
contents=cellstr(get(hObject,'String'));
popchoice=contents(get(hObject,'Value'));
fs = 8000;
if (strcmp(popchoice,'Hanning'))
    handles.w = hann(floor(((handles.seg)/1000)*fs), 'periodic'); % using Hann window
    %disp(handles.w)
    disp(popchoice);
elseif (strcmp(popchoice,'Hamming'))
    handles.w = hamming(floor(((handles.seg)/1000)*fs), 'periodic'); % using Hann window
    disp(popchoice);
elseif (strcmp(popchoice,'Bartlett'))
    handles.w = bartlett(floor(((handles.seg)/1000)*fs)); % using Hann window
    disp(popchoice);
elseif (strcmp(popchoice,'Blackman'))
    handles.w = blackman(floor(((handles.seg)/1000)*fs), 'periodic'); % using Hann window
    disp(popchoice);
end
guidata(hObject, handles);
%************************************************************
%************************************************************
% --- Executes on button press in recorder.
%For recording the audio
function recorder_Callback(hObject, eventdata, handles)
disp('Start speaking')
handles.recObj = audiorecorder(44100,16,1);
recordblocking(handles.recObj,handles.rectime)
handles.y = getaudiodata(handles.recObj);
audiowrite('input.wav',handles.y,44100)
[handles.y, handles.Fs] = audioread('input.wav');
handles.player = audioplayer(handles.y, handles.Fs);
disp('End speaking')
guidata(hObject, handles);
%************************************************************
% --- Executes on button press in player.
%For playing the audio
function player_Callback(hObject, eventdata, handles)
axes(handles.axes1);
plot(handles.y);
xlabel('Time');
ylabel('Magnitude');
play(handles.player)

%************************************************************
% --- Executes on button press in pushbutton12.
% For displaying/plotting coefficients(go button of order of filter)
function pushbutton12_Callback(hObject, eventdata, handles)
[x, fs] = audioread('input.wav');
x = mean(x, 2); % mono
x = 0.9*x/max(abs(x)); % normalize
x = resample(x, 8000, fs);% resampling to 8kHz
[handles.A, handles.G] = lpcEncode(x, handles.p, handles.w, handles.ol);
guidata(hObject, handles);
disp(handles.A)
%*******************************************************
% --- Executes on selection change in popupmenu3.
%Order of filter dropdown menu
function popupmenu3_Callback(hObject, eventdata, handles)
contents=cellstr(get(hObject,'String'));
popchoice=contents(get(hObject,'Value'));
if (strcmp(popchoice,'12'))
    handles.p=12;
    disp(popchoice);
elseif (strcmp(popchoice,'48'))
    handles.p=48;
    disp(popchoice);
elseif (strcmp(popchoice,'72'))
    handles.p=72;
    disp(popchoice);
elseif (strcmp(popchoice,'96'))
    handles.p=96;
    disp(popchoice);
end
guidata(hObject, handles);
%*******************************************************
%**********************************************************
% --- Executes on button press in pushbutton7.
%For calculating pitch
function pushbutton7_Callback(hObject, eventdata, handles)
[x, fs] = audioread('input.wav');
x = mean(x, 2); % mono
x = 0.9*x/max(abs(x)); % normalize
x = resample(x, 8000, fs);% resampling to 8kHz

[handles.ff, handles.pow] = lpcFindPitch(x, handles.w, 5, 0.125, -60, 0.5,handles.ol);
disp('Pitch')
disp(handles.ff)
disp('Power:')
disp(handles.pow)
axes(handles.axes1);
plot(handles.ff)
xlabel('Segment Number');
ylabel('Fundamental Frequency of the Segment');
guidata(hObject, handles);
%**********************************************************
%********************************************************
% --- Executes on button press in pushbutton8.
%Reconstruction without pitch
function pushbutton8_Callback(hObject, eventdata, handles)

[x, fs] = audioread('input.wav');
x = mean(x, 2); % mono
x = 0.9*x/max(abs(x)); % normalize
x = resample(x, 8000, fs);% resampling to 8kHz

handles.xhat = lpcDecode(handles.A, handles.G, handles.w);

% listen to resynthesized signal
handles.apLPC = audioplayer(handles.xhat, 8000);
disp('Display reconstructed signal without pitch:')
disp(handles.apLPC)

% compare amount of data
nSig = length(x);
disp(['Original signal size: ' num2str(nSig)]);
sz = size(handles.A);
nLPC = sz(1)*sz(2) + length(handles.G);
disp(['Encoded signal size: ' num2str(nLPC)]);
disp(['Data reduction: ' num2str(nSig/nLPC)]);

% save result to file
audiowrite('output_without_pitch.wav',handles.xhat, 8000);
guidata(hObject, handles);
%****************************************************
% --- Executes on button press in pushbutton13.
function pushbutton13_Callback(hObject, eventdata, handles)
axes(handles.axes1);
plot(handles.xhat);
xlabel('Time');
ylabel('Magnitude');
play(handles.apLPC); 

%********************************************************
%*****************************************************
% --- Executes on button press in pushbutton9.
%Reconstruction with pitch
function pushbutton9_Callback(hObject, eventdata, handles)

%[x, fs] = audioread('input.wav');
%x = mean(x, 2); % mono
%x = 0.9*x/max(abs(x)); % normalize
%x = resample(x, 8000, fs);% resampling to 8kHz

fs=8000;
handles.xhat = lpcDecode(handles.A, handles.G, handles.w, 200/fs);
% listen to resynthesized signal
handles.apLPC = audioplayer(handles.xhat, fs);
%disp(handles.apLPC);

% compare amount of data
%nSig = length(x);
%disp(['Original signal size: ' num2str(nSig)]);
%sz = size(handles.A);
%nLPC = sz(1)*sz(2) + length(handles.G);
%disp(['Encoded signal size: ' num2str(nLPC)]);
%disp(['Data reduction: ' num2str(nSig/nLPC)]);

% save result to file
audiowrite('output_with_pitch.wav',handles.xhat, fs);
guidata(hObject, handles);
%*****************************************************
%***********************************************
% --- Executes on button press in pushbutton14.
function pushbutton14_Callback(hObject, eventdata, handles)
axes(handles.axes1);
plot(handles.xhat);
xlabel('Time');
ylabel('Magnitude');
play(handles.apLPC); 

%***********************************************
%*******************************************************************************
% --- Executes during object creation, after setting all properties.
%For plotting the plot of pitch
function axes1_CreateFcn(hObject, eventdata, handles)

funcString = get(handles.axes1,'String');
funcHandle = str2func(['@(x)' funcString]);
x = linspace(0,4,100);
y = funcHandle(x);
plot(handles.axes1,x,y);
%****************************************************************************
%********************************************************
function overlap_Callback(hObject, eventdata, handles)
handles.ol=str2double(get(hObject,'String'));
disp(handles.ol)
guidata(hObject, handles);

%********************************************************
%***********************************************
% --- Executes on button press in pushbutton11.
function pushbutton11_Callback(hObject, eventdata, handles)


%***********************************************
% --- Executes during object creation, after setting all properties.
function window_CreateFcn(hObject, eventdata, handles)

%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%*********************************************************
% length of audio segment
function segment_Callback(hObject, eventdata, handles)
handles.seg=str2double(get(hObject,'String'));
disp(handles.seg)
guidata(hObject, handles);

%*********************************************************
%*********************************************************
%Input time for recording speech
function time_Callback(hObject, eventdata, handles)
handles.rectime=str2double(get(hObject,'String'));
guidata(hObject, handles);

%*********************************************************
% --- Executes during object creation, after setting all properties.
function segment_CreateFcn(hObject, eventdata, handles)


% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function overlap_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit5_Callback(hObject, eventdata, handles)
% --- Executes during object creation, after setting all properties.

function edit5_CreateFcn(hObject, eventdata, handles)
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function pushbutton10_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function popupmenu3_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function time_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
