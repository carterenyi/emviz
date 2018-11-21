function varargout = EMVizGUI(varargin)
% EMVIZGUI MATLAB code for EMVizGUI.fig
%      EMVIZGUI, by itself, creates a new EMVIZGUI or raises the existing
%      singleton*.
%
%      H = EMVIZGUI returns the handle to a new EMVIZGUI or the handle to
%      the existing singleton*.
%
%      EMVIZGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in EMVIZGUI.M with the given input arguments.
%
%      EMVIZGUI('Property','Value',...) creates a new EMVIZGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before EMVizGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to EMVizGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help EMVizGUI

% Last Modified by GUIDE v2.5 28-Oct-2017 09:19:53

try
    addpath('~/emviz-master/')
    addpath('~/emviz-master/emvizscripts/')
catch
    try
        addpath('~/emvizscripts/')
    catch
        msg = 'EMViz not found in current directory.';
        error(msg)
        return
    end
end

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @EMVizGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @EMVizGUI_OutputFcn, ...
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


% --- Executes just before EMVizGUI is made visible.
function EMVizGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to EMVizGUI (see VARARGIN)

% Choose default command line output for EMVizGUI
handles.output = hObject;
handles.filename=[];
handles.pathname=[];
handles.stringSelect{1}='initialize';
handles.stringNumbers=[];
handles.r=[];
handles.nmatFound=[];
handles.nmat=[];
xlabel(handles.axes1,'Time (Beats)');
ylabel(handles.axes1,'Pitch (C4=60)');
ylim([55 67])
xlim([0 8])


% Update handles structure
guidata(hObject, handles);

% UIWAIT makes EMVizGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = EMVizGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cla
handles.filename
handles.r=[];
handles.stringSelect=[];
handles.stringNumbers=[];
handles.nmat=[];
handles.nmatFound=[];
title=get(handles.edit2,'String');
type=get(handles.listbox3,'Value')
try
cmin=str2num(get(handles.edit3,'String'));
catch
    cmin=5;
end
if strcmp(title,'')
    title=handles.filename;
end
[r,nmat,nmatFound]=searchAndPlotPolyOrMono([handles.pathname handles.filename],title,type,cmin)
n=numel(r)
strings={};
for i =1:n
    strings{i}=strcat('String ',num2str(i));
end
set(handles.listbox1,'Value',1);
set(handles.listbox1,'String',strings);
set(handles.r,'Value',r);
handles.r=r;
set(handles.nmat,'Value',nmat);
handles.nmat=nmat;
set(handles.nmatFound,'Value',nmatFound);
handles.nmatFound=nmatFound;
 guidata(hObject,handles);


%% "SELECT MIDI FILE"
% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cla
handles.filename = [];
handles.pathname = [];
%handles.text9=[];
strings=[];
handles.stringSelect=[];
stringSelect=handles.stringSelect
set(handles.listbox1,'String',strings);
set(handles.listbox2,'String',stringSelect);
set(handles.edit1,'String','');
set(handles.edit2,'String','');
[filename, pathname] = uigetfile('*.mid');
 set(handles.filename, 'String',filename);
 handles.filename = filename
 set(handles.pathname, 'String',pathname);
 handles.pathname = pathname;
  set(handles.text9, 'String',filename);
  %handles.text9 = filename;
 guidata(hObject,handles);


% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox1


% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in replot.
function replot_Callback(hObject, eventdata, handles)
% hObject    handle to replot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%set(handles.listbox2,'Value',[]);

stringNumbers=handles.stringNumbers;
stringSelect=handles.stringSelect;

r=handles.r;
nmat=handles.nmat;
nmatFound=handles.nmatFound
title=get(handles.edit2,'String');
if strcmp(title,'')
    title=handles.filename;
end
stringSelect
stringNumbers
if isempty(stringNumbers)==1
 r=arcPlot(r,nmat,nmatFound,title,0);   
else
r=arcPlot(r,nmat,nmatFound,title,0,stringNumbers,stringSelect);
end
handles.stringSelect=[];
handles.stringNumbers=[];
stringSelect=handles.stringSelect
set(handles.listbox2,'String',stringSelect);
guidata(hObject,handles);


% --- Executes on selection change in listbox2.
function listbox2_Callback(hObject, eventdata, handles)
% hObject    handle to listbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox2


% --- Executes during object creation, after setting all properties.
function listbox2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%listBoxStrings = get(handles.listbox1,'String');
stringSelect=handles.stringSelect;
stringNumbers=handles.stringNumbers;
temp=get(handles.listbox1,'Value')
stringNumbers(end+1)=temp;
temp2=get(handles.edit1,'String')
if iscell(temp2)==1
stringName=temp2{1};
else
    stringName=temp2;
end
set(handles.edit1,'String','');
try
stringSelect{1}
catch
    stringSelect
end
stringName
try
    if strcmp(stringSelect{1},'initialize')==1
        if strcmp(stringName,'')==1
        stringSelect{1}=strcat('String ',num2str(temp));
        else
          stringSelect{1}=stringName;  
        end
    elseif strcmp(stringName,'')==1

        stringSelect{end+1}=strcat('String ',num2str(temp));
    else
          stringSelect{end+1}=stringName;  
    
    end
catch
        if strcmp(stringName,'')==1
        stringSelect{end+1}=strcat('String ',num2str(temp));
        else
          stringSelect{end+1}=stringName;  
        end
end
handles.stringSelect=[];
handles.stringNumbers=[];
stringSelect
set(handles.listbox2,'String',stringSelect);
set(handles.stringSelect,'String',stringSelect);
handles.stringSelect=stringSelect;
set(handles.stringNumbers,'Value',stringNumbers);
handles.stringNumbers=stringNumbers;
handles.stringNumbers
guidata(hObject,handles);


function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double



% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in plotString.
function plotString_Callback(hObject, eventdata, handles)
% hObject    handle to plotString (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cla
r=handles.r;
nmatFound=handles.nmatFound;
temp=get(handles.listbox1,'Value');
card=r(temp).card;
ind=r(temp).segind(1);
%axes(handleToAxes1);
hold on
timeAdj=floor(nmatFound(ind,1));
for i=1:card
    pitches(i)=nmatFound(ind+i-1,4)
    onsets(i)=nmatFound(ind+i-1,1)
plot([nmatFound(ind+i-1,1)-timeAdj,nmatFound(ind+i-1,1)+nmatFound(ind+i-1,2)-timeAdj],...
    [nmatFound(ind+i-1,4),nmatFound(ind+i-1,4)],'Color','k','LineWidth', 10);
% if i>10
%     break
% end
end
ylim([min(pitches)-3 max(pitches)+3]);
xlim([onsets(1)-1-timeAdj onsets(end)+2-timeAdj]);

hold off

nmat=nmatFound(ind:ind+card-1,:)
nmat(:,1)=nmat(:,1)-nmat(1,1);
soundsc(nmat2snd(nmat),22050);



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in listbox3.
function listbox3_Callback(hObject, eventdata, handles)
% hObject    handle to listbox3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox3 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox3


% --- Executes during object creation, after setting all properties.
function listbox3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

nmatFound=nmatMono2poly(handles.nmat,handles.nmatFound)
r=handles.r;
if isempty(handles.stringNumbers)==1
    rRef=1:numel(r)
else
    rRef=handles.stringNumbers;
end


segs=1:5;
for i=1:numel(rRef)
    k=rRef(i);
    for j=1:numel(r(k).segind)
        segs(end+1,:)=1:5;
        segs(end,1)=k;
        segs(end,2)=r(k).card;
        segs(end,3:5)=nmatFound(r(k).segind(j),[3,1,4]);
    end
end
segs(1,:)=[];
String=segs(:,1);
Cardinality=segs(:,2);
Channel=segs(:,3);
Onset=segs(:,4);
Pitch=segs(:,5);
T=table(String,Cardinality,Channel,Onset,Pitch);
temp=handles.filename(1:end-4);
Tfilename=[handles.pathname temp '.csv'];
writetable(T,Tfilename);
