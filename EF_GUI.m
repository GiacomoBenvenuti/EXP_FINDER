function varargout = EF_GUI(varargin)
%EF_GUI M-file for EF_GUI.fig
%      EF_GUI, by itself, creates a new EF_GUI or raises the existing
%      singleton*.
%
%      H = EF_GUI returns the handle to a new EF_GUI or the handle to
%      the existing singleton*.
%
%      EF_GUI('Property','Value',...) creates a new EF_GUI using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to EF_GUI_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      EF_GUI('CALLBACK') and EF_GUI('CALLBACK',hObject,...) call the
%      local function named CALLBACK in EF_GUI.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help EF_GUI

% Last Modified by GUIDE v2.5 17-Apr-2017 16:01:11

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @EF_GUI_OpeningFcn, ...
    'gui_OutputFcn',  @EF_GUI_OutputFcn, ...
    'gui_LayoutFcn',  [], ...
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


% --- Executes just before EF_GUI is made visible.
function EF_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% Initialize Monkeys and Protocols lists

s= what(['DATABASE']);
cd(s.path);
handles.output = hObject;
[MonkName, ProtNames,MN] = initGUI;

% Set
set(handles.MonkeyName,'String', ['Show_All' MonkName],'max',size(MN,2));
set(handles.Protocol,'String', ['Show_All' ProtNames],'max',size(MN,2));

% info ------
STX=['HELP'  char(10) 'To start you have 2 options: ' char(10) char(10) ' 1. Select one '...
    'or more Monkey names' char(10) char(10) ' 2. Select one Protocol' ...
    char (10)  char(10) '    ------------------- ' char(10) 'Database last update 6/10/2016'];
set(handles.Support,'String',STX)
% ----------

% Save
handles.MonkNameAll = ['Show_All' MonkName];
handles.ProtName = ['Show_All'  ProtNames];

handles.Selected_Monkeys = 'Show_All'; % index
handles.Selected_Protocols = ['Show_All'  ProtNames];
handles.FlagProtSelection=0;
guidata(hObject, handles);




% --- Outputs from this function are returned to the command line.
function varargout = EF_GUI_OutputFcn(hObject, eventdata, handles)

varargout{1} = handles.output;


% --- Executes on selection change in MonkeyName.
function MonkeyName_Callback(hObject, eventdata, handles)
s= what(['DATABASE']);
cd(s.path);

% LOAD
handles=guidata(hObject);
MNtmp=handles.MonkNameAll;
ProtNames = handles.ProtName;
Sel_PRT = handles.Selected_Protocols;
flagPS= handles.FlagProtSelection;
Sel_Monk = handles.Selected_Monkeys;
%set(hObject,'String',MN,'max',size(MN,2));

% GET
%MN =MNtmp(2:end);
SL_MN = get(hObject,'Value')

% PROCESS
if SL_MN==1
    set(handles.MonkeyName,'String', ...
        [MNtmp],'max',size(MNtmp,2),'Value',1);
    
    set(handles.Protocol,'String', [ProtNames],'max',size(MNtmp,2));
    handles.Selected_Monkeys = MNtmp,; % index
    handles.Selected_Protocols =ProtNames;
    handles.FlagProtSelection =0;
else
    
    if ~flagPS
        
        % PROCESS
        SMN=MNtmp(SL_MN)
        % for multiple monkeys selection find which protocol
        % they have in common
        for i = 1:size(SMN,2)
            n = [SMN{i} 'PList']
            load( n );
            eval(['tm = fieldnames(' n ')']);
            ProtList{i}=tm;
        end
        
        for i = 1:size(ProtList,2)
            CompProt(:,i) = ismember(ProtList{1},ProtList{i})
        end
        CP = sum( CompProt,2);
        CPIndex = find(CP == size(ProtList,2));
        Sel_PRT = ProtList{1}(CPIndex);
        handles.Selected_Monkeys = MNtmp(SL_MN);
    else
        handles.Selected_Monkeys =Sel_Monk(SL_MN);
     
    end
    set(handles.Protocol,'String',[ Sel_PRT],'Value',2);
    
    % SAVE
    handles.Selected_Protocols = ['Show_All'; Sel_PRT];
   
end



% info ------
STX=['HELP'  char(10) '* When you select a monkey name,' ...
    ' the Protocol listbox is updated with only the Protocols available ' ...
    'for that monkey.'  ...
    '* If you select multiple monkey names, the Protocol Listbox is updated ' ...
    'with the list of only the Protocols available for all selected monkeys' char(10) ...
    '* To RESET select Show_All at the top of the List boxes'  ];
set(handles.Support,'String',STX)
% ----------


guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function MonkeyName_CreateFcn(hObject, eventdata, handles)
% hObject    handle to MonkeyName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in Protocol.
function Protocol_Callback(hObject, eventdata, handles)
s= what(['DATABASE'])
cd(s.path);

% LOAD
handles=guidata(hObject);
SMK=handles.Selected_Monkeys; % use the custum monkey selection
Sel_Prot=handles.Selected_Protocols ;
ProtName=handles.ProtName;
MNtmp=handles.MonkNameAll;
MN =MNtmp(2:end);

% GET
PRTn= get(hObject,'Value'); % get user selection

% PROCESS
if PRTn==1  % account for Show_All selection (RESET)
    set(handles.MonkeyName,'String', ...
        ['Show_All' MN],'max',size(MN,2),'Value',1);
    
    set(handles.Protocol,'String', [ProtName],'max',size(MN,2));
    handles.Selected_Monkeys = MNtmp,; % index
    handles.Selected_Protocols =ProtName;
    handles.FlagProtSelection =0;
else
    
    % PROCESS
    PN=Sel_Prot(PRTn); % get name of selected protocol
    PNs =['PRT_' PN{1}]; % cell 2 string
    LiST = dir(PNs); % find monkey files in the protocol folder
    MonkList = {LiST.name}
    PNs(1:4) = [];
    % find all monkeys for that protocol (PNs)
    % correspond to the files names within the Prot
    % folder
    ct=0;
    for i = 1:size(MonkList,2)
        tm = MonkList{i};
        ts = strfind(tm , PNs)
        if ~isempty(ts)
            ct=ct+1;
            MNP{ct} = tm(1:ts-1);
        end
        
    end
    
    NewMonkSel=find(ismember(SMK,MNP)==1)
    if NewMonkSel==0
        NewMonkSel=1;
    end
    
    % Mlist{1} = 'Show_All' ;
    % for i =2:size(MNP,2)+1
    %     Mlist{i} = MNP{i-1};
    % end
    
    % SET
    set(handles.MonkeyName,'String',['Show_All' MNP],'max',size(MNP,2)+1,'Value',NewMonkSel);
    set(handles.Protocol,'String',['Show_All' PN']','Value',2);
    drawnow;
    
    % SAVE
    handles.Selected_Monkeys = ['Show_All' MNP];
    
   if strcmp(PNs,'Show_All')
    handles.Selected_Protocols =[ {PNs}];
   else
        handles.Selected_Protocols =['Show_All'; {PNs}];
   end
    handles.FlagProtSelection =1;
    handles
end


% info ------
if  PRTn==1 % account for Show_All selection (RESET)
    STX=['HELP'  char(10) '!!! the research was manually resetted !!!' char(10)  ...
        '* When you select a Protocol name,' ...
        ' the Monkey listbox is updated with all the monkey names for which  ' ...
        'the selected protocl is available' char(10) ...
        '* To RESET select Show_All at the top of the List boxes'];
    
else
    STX=['HELP'  char(10) '* When you select a Protocol name,' ...
        ' the Monkey listbox is updated with all the monkey names for which  ' ...
        'the selected protocl is available' char(10) ...
        '* To RESET select Show_All at the top of the List boxes'];
end
set(handles.Support,'String',STX)

% ----------


% SAVE
guidata(hObject, handles);



% --- Executes during object creation, after setting all properties.
function Protocol_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in ExpList.
function ExpList_Callback(hObject, eventdata, handles)
% hObject    handle to ExpList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns ExpList contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ExpList


% --- Executes during object creation, after setting all properties.
function ExpList_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ExpList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Update_Parameters.
function Update_Parameters_Callback(hObject, eventdata, handles)
handles=guidata(hObject);
tm = handles.Selected_Monkeys;
Sel_PRT = handles.Selected_Protocols;
Sel_Monk ={ tm{2:end}};

% Info ------------
STX=['Selection :' char(10) ...
    'Monkeys: ' Sel_Monk char(10) ...
    'Protocol:' Sel_PRT(2,:)];

set(handles.Support,'String',STX)
%-----------------

% GET
%UPD= get(hObject,'Value'); % get user selection
% get table

% PROCESS
% CreateParamTab
sp=what(['PRT_' Sel_PRT{2}]);

for i = 1:size(Sel_Monk,2)
    tm = [Sel_Monk{i} Sel_PRT{2}];
    load([sp.path '/' tm])
    eval(['mm{i} = ' tm]);
    s = size(mm{1},2);
    txx = [' mm{' num2str(i) '}''']
    L(1,(1:numel(txx))+(numel(txx)*(i-1) ) ) = txx ;
end

% Check if struct diff monkeys have the same num of fields!

eval(['ParamTab = [' L ']' ]);

ParamNames = fieldnames(ParamTab);

for i = 1: size(ParamNames,1 )
    Cond{i} = unique([ParamTab.(ParamNames{i})]);
    SelTab{i} = nan;
end

T = table(ParamNames, Cond',SelTab')
%T =table([1:3]',[1:3]',[0 0 0 ]');

% SET
set(handles.uitable1,'Data',T{:,:} ,'ColumnName',{'Param' , 'Options', 'Select' },  'ColumnEditable',[false false true],'ColumnWidth',{130 180 60});

set(handles.ExpList,'String',s)
% PT = uitable
%
% CreateExpTab
% UpdateTable
% UpdateExpTab
%set(handles.ExpList, 'String', ParamTab)


guidata(hObject, handles);


% --- Executes on button press in Print.
function Print_Callback(hObject, eventdata, handles)
% hObject    handle to Print (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in Update_Database.
function Update_Database_Callback(hObject, eventdata, handles)
% Select /data folder

% Import all .log files

% Tempo??

CreateProtocolSummary

%save LastUpdate file
