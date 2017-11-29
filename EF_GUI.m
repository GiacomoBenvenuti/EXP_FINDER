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

% Last Modified by GUIDE v2.5 31-May-2017 18:18:17

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

FN = mfilename('fullpath')
tm = FN(1:size(FN,2)-6);
MyDataFolder = [tm 'DATABASE_EF'];

cd (MyDataFolder)
handles.output = hObject;
[MonkName, ProtNames,MN] = initGUI;

% Set
set(handles.MonkeyName,'String', ['Show_All' MonkName],'max',size(MN,2));
set(handles.Protocol,'String', ['Show_All' ProtNames],'max',size(MN,2));
load Last_Update
set(handles.LastUD,'String',['Last UPDATE ' Last_Update])

% info ------
STX=['HELP'  char(10) 'To start you have 2 options: ' char(10)... 
    ' 1. Select one or more Monkey names on the top left listbox' char(10)  ' 2. Select one Protocol on the listbox beside that' ...
    char (10)  char(10)];

set(handles.Support,'String',STX)
% ----------

% Save
handles.MonkNameAll = ['Show_All' MonkName]';
handles.ProtName = ['Show_All'  ProtNames]';

handles.Selected_Monkeys = ['Show_All' MonkName]';
handles.Selected_Protocols = ['Show_All' ; ProtNames'];
handles.FlagProtSelection=0;
handles.flag_Create_Tab = 0;
handles.MyDataFolder = MyDataFolder;
handles.SelectedExperimentsID =[];


guidata(hObject, handles);




% --- Outputs from this function are returned to the command line.
function varargout = EF_GUI_OutputFcn(hObject, eventdata, handles)

varargout{1} = handles.output;


% --- Executes on selection change in MonkeyName.
function MonkeyName_Callback(hObject, eventdata, handles)
% s= what(['DATABASE']);
% cd(s.path);

% LOAD
handles=guidata(hObject);

MNtmp=handles.MonkNameAll;
ProtNames = handles.ProtName;
Sel_PRT = handles.Selected_Protocols;
flagPS= handles.FlagProtSelection;
Sel_Monk = handles.Selected_Monkeys;
%set(hObject,'String',MN,'max',size(MN,2));
MyFold = handles.MyDataFolder;
cd(MyFold);

% GET
%MN =MNtmp(2:end);
SL_MN = get(hObject,'Value');

% PROCESS
if SL_MN==1
    set(handles.MonkeyName,'String', ...
        [MNtmp],'max',size(MNtmp,2),'Value',1);
    
    set(handles.Protocol,'String', ProtNames','max',size(MNtmp,2));
    handles.Selected_Monkeys = MNtmp,; % index
    handles.Selected_Protocols =ProtNames;
    handles.FlagProtSelection =0;
else
    
    if ~flagPS
        
        % PROCESS
        SMN=MNtmp(SL_MN);
        % for multiple monkeys selection find which protocol
        % they have in common
        for i = 1:size(SMN,2)
            n = [SMN{i} 'PList'];
            load( n );
            eval(['tm = fieldnames(' n ')']);
            ProtList{i}=tm;
        end
        
        for i = 1:size(ProtList,2)
            CompProt(:,i) = ismember(ProtList{1},ProtList{i});
        end
        CP = sum( CompProt,2);
        CPIndex = find(CP == size(ProtList,2));
        Sel_PRT = ProtList{1}(CPIndex);
      
        handles.Selected_Monkeys = MNtmp(SL_MN);
        
    else
    %    handles.Selected_Monkeys =Sel_Monk(SL_MN);
 
    end
     tm = strcmp(Sel_PRT,'Show_All');
      if  tm(1 )== 1
       handles.Selected_Protocols = [ Sel_PRT];
      set(handles.Protocol,'String',[ Sel_PRT],'Value',2);
      else
      set(handles.Protocol,'String',['Show_All'; Sel_PRT],'Value',2);
       handles.Selected_Protocols = ['Show_All'; Sel_PRT];
      end
    
    % SAVE
 
   
end



% info ------
  if  flagPS

STX={'HELP ' ...
   'You have selected a Protocol!' ...
   'Now now you can readjust your monkeys ' ...
   'selection if you like. ' ...
   'Then PUSH THE UPDATE PARAMETERS button' ...
    ' ' ...
    '* To RESET select Show_All at the top of the List boxes' };
  else 
      STX={'HELP ' ...
    '* When you select a Monkey name the' ...
    'Protocols listbox is updated with only ' ...
    'the Protocols available for that monkey.'  ...
    ' ' ...
    '* If you select multiple Monkey (use CTRL button), ' ...
    'the Protocols Listbox is updated with  ' ...
    'the list of only the Protocols available for' ... 
    'all selected Monkeys'  ...
    ' ' ...
    '* To RESET your research select Show_All at the top of the List boxes' };
  end

% STX=['Sel Prot =' handles.Selected_Protocols' char(10) ...
%     'Sel Monk = ' handles.Selected_Monkeys' ];
set(handles.Support,'String',STX)
% ----------

handles.flag_Create_Tab = 0;
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
% s= what(['DATABASE'])
% cd(s.path);

% LOAD
handles=guidata(hObject);
SMK=handles.Selected_Monkeys; % use the custum monkey selection
Sel_Prot=handles.Selected_Protocols ;
ProtName=handles.ProtName;
MNtmp=handles.MonkNameAll;
MyFold = handles.MyDataFolder;
%MN =MNtmp(2:end);
cd(MyFold)
% GET
PRTn= get(hObject,'Value'); % get user selection

% PROCESS
if PRTn==1  % account for Show_All selection (RESET)
    set(handles.MonkeyName,'String', ...
       MNtmp,'max',size( MNtmp,2),'Value',1);
    
    set(handles.Protocol,'String', [ProtName],'max',size(ProtName,2));
    handles.Selected_Monkeys = MNtmp; % index
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
        ts = strfind(tm , PNs);
        if ~isempty(ts)
            ct=ct+1;
            MNP{ct} = tm(1:ts-1);
        end
        
    end
    
    NewMonkSel=find(ismember(['Show_All'  MNP],SMK)==1)
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
    handles.Selected_Monkeys = ['Show_All'; MNP'];
    
   if strcmp(PNs,'Show_All')
        handles.Selected_Protocols =[ {PNs}]
   else
        handles.Selected_Protocols =['Show_All'; {PNs}]
   end
   
   handles.FlagProtSelection =1;
   
end


% info ------
if  PRTn==1 % account for Show_All selection (RESET)
    STX={'HELP' ...
        '!!! the research was manually resetted !!!'  ...
        '* When you select a Protocol name,' ...
        'the Monkeys listbox is updated with all ' ...
        'the monkey names for which the selected  ' ...
        'protocol is available --> Select one or more ' ...
        'Monkeys (using the CNTRL button) and PUSH UPDATE PARAMETERS button' ...
        ' ' ...
       '* To RESET the two lists select Show_All at' ...
        'the top of the List boxes'};
    
else
 STX={'HELP' ...
        '* When you select a Protocol name,' ...
        'the Monkeys listbox is updated with all ' ...
        'the monkey names for which the selected  ' ...
        'protocl is available --> Select one or more ' ...
        'Monkeys and PUSH the "UPDATE PARAMETERS" button' ...
        ' ' ...
        '* To RESET the two lists, select Show_All at' ...
        'the top of the List boxes'};
end


set(handles.Support,'String',STX)

% ----------

handles.flag_Create_Tab = 0;
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
set(handles.figure1,'color',[1 .5 .5]) % change Menu color to red
drawnow
% Load data from handle
handles=guidata(hObject);
flagUD = handles.flag_Create_Tab;
Sel_PRT = handles.Selected_Protocols;
MM = handles.Selected_Monkeys;
DF = handles.MyDataFolder; 

% Check Selection Protocols List
if size(Sel_PRT,1) >2
   h = errordlg('You need to select a Protocol from the listbox above to continue ', 'EXP_FINDER')
   uiwait(h)
   set(handles.figure1,'color',[.94 .94 .94])
   drawnow
   error('Select one Protocol!!')
end
 
% Check selection Monkey List (GUI)
tm = get(handles.MonkeyName,'Value');
Sel_Monk ={ MM{tm}};

% Get rid of 'Show All' field
if sum(ismember(Sel_Monk,'Show_All'))>0
 Sel_Monk = setdiff(Sel_Monk,'Show_All');
end
    
% This flag indicates if it is the first time you generate the 
% Protocol list or you are updating it after changing something 
% in the tab
if flagUD == 0

% Info ------------
clear STX
STX=({'SELECTION : '   ... 
    'Monkeys: ' Sel_Monk{:}  ...
    'Protocol:' Sel_PRT{2,:}   ...
    '----------------'  ...
    'HELP'  ...
    'In the top rigth table you can select one or' ...
    'more parameters from the Options' ...
    'column (#2) writing them separete by a ' ...
    'comma within the Selection column (#3)' ...
    '(replacing the "All") ' ...
    ' ' ...
    'To RESET click  the RESET TAB button uder the Tab '});

set(handles.Support,'String',STX)
%-----------------

% PROCESS - Init PARAM LIST
 sp=([DF filesep 'PRT_' Sel_PRT{2}]); % use data .mat files in the internal database
clear L
%L='                                                                                                                                                           '
for i = 1:size(Sel_Monk,2)
    tm = [Sel_Monk{i} Sel_PRT{2}];
    load([sp '/' tm])
    eval(['mm{i} = ' tm]);
    s = size(mm{1},2);
    fn{i} =fieldnames(mm{i});
    nf(i)=size( fn{i},1);
    clear txx
    txx = [' mm{' num2str(i) '}'] ;
 %   L(1,((1:numel(txx)))   +    ((numel(txx))*(i-1) ) ) = txx ;
 %  L(1,(1:7)+((7)*(i-1) ) ) = txx ;
   L2{i} = txx;
end
L = [L2{:}];


% Check if struct diff monkeys have the same num of fields!
if ~(sum(nf)==nf(1)*(numel(nf))) 
d = questdlg(['The number of parameters ' ...
    'is not the same for all monkeys!' char(10) ...
    '[' num2str(nf) ']. Do you want to continue anyway?'] )

if  strcmp(d, 'Yes') == 1
 
 AllFileds = unique(cat(1,fn{:})); 
 
  for i = 1:size(fn,2)
       for y = 1: size(AllFileds,1)
            if  ~isfield(mm{i}, AllFileds{y});
                for k = 1:size(mm{i},2)
                 eval(['mm{i}(1,k).' AllFileds{y} ' = nan']);
                end
           end
          end
   end
 %  errordlg('I still have to do this part :) ','Different param number');  
%    [a b] = max(nf(:)) ;
%    LessP = find(nf<a);
%      
%    DiffParamInd =  fn{b}(find(ismember(fn{b}, fn{ LessP(1) }) ==0));
%   
%    for i = 1:numel(LessP)
%        for y = 1: numel(DiffParamInd )
%            for q =1:size(mm{LessP(i)},2)
%         eval([' mm{LessP(i)}(1,q).' DiffParamInd{y} ' = nan']);
%        end
%    end
%    end
%   
   % use fn
else
    errordlg('Select a new group of Monkeys!','Different param number');
     error('You stopped the process: Select a new group of Monkeys!');
end
end

eval(  [ 'ParamTab = [' L ']' ]  )  ;% full Tab 


ParamTabUD = ParamTab;  % ParamTabUD is the one that will be updated
handles.ParamTab = ParamTab;
handles.ParamTabUD = ParamTabUD;
handles.Msg = {'  '};

else %-----------------------------------------------
    %--------------------------------------------------
    
% PARAMETERS TAB USER INPUT    
% If user change tab field 'Select' update the Tab
ParamTabUD=handles.ParamTabUD;
Condx = handles.Cond;
Msg = handles.Msg;

%GET - find which field has been modified in the param tab
TabModif = get(handles.uitable1,'Data');
FieldCol =  TabModif(:,1);
SelCol=[{TabModif{:,3}}];
[a s1 ] = find(strcmp('All',SelCol) ==0);
if numel(s1)>0 % go on only if user modified the Tab
InpField = FieldCol(s1);

for i =1:numel(s1)
CondSel{i} = str2num(Condx{s1(i)}) ; % Possible field values

InpVal{i} =  str2num(cell2mat(SelCol(s1(i)))); % value selected by the user

MTCH{i} = isempty(intersect(CondSel{i},InpVal{i})); % chack if the user selected one oof the possible values
end 

if find([MTCH{:}]==0) ==0
   errordlg('Your selection is not correct: copy one or more values separated by a comma from the Option column (#2)');
else 

% Find Exp index with selected param value
for i = 1: numel(InpVal)
  % put together EXP matching multiple selections 'OR'
  clear tm tm1
  for h = 1:size(InpVal{i},2) % test all user selections
       tmExp=[];
      ct=0;
      for e =1:size(ParamTabUD,2) % some fields have more than a single value
          if find ([ParamTabUD(e).(InpField{i})] == InpVal{i}(h))  > 0
              ct=ct+1;
              tmExp(ct) = e;
          end
      end
      tm{h}= tmExp(:)';
  end
  tm1 = unique( [tm{:}]);
  SelExpInd_All{i} = tm1;
  
  Msg{size(Msg,2)+1} = cell2mat([InpField{i} '=  '  {num2str(InpVal{i})}]);

end
% find intersection among exp indexes selected based on different params
clear SelExpInd
SelExpInd = mintersect(SelExpInd_All{:});

if isempty(SelExpInd )
     errordlg('There are no experiments matching your selection!');
else
    

ParamTabUD = ParamTabUD(SelExpInd); % ParamTab Updated
handles.ParamTabUD = ParamTabUD;



end  % List of exceptions
end
end
% Info ------------
clear STX
% 'SELECTION : '   ... 
%   'Monkeys: ' Sel_Monk{:}  ...
%     'Protocol:' Sel_PRT{2,:}   ...
STX={ 'PARAM SELECTION' ...
    Msg{:} ...
    '----------------'  ...
    'HELP'  ...
    'In the top rigth table you can select one or' ...
    'more parameters from the Options' ...
    'column (#2) writing them separete by a ' ...
    'comma within the Selection column (#3)' ...
    '(replacing the "All") ' ...
    ' ' ...
    'If you click on a field of the Option column' ...
    'you will see here the full content' ...
    ' ' ...
    'To RESET click the RESET TAB button uder the Tab '};

set(handles.Support,'String',STX)
%-----------------

handles.Msg = Msg;
end % only first time --------------------------------------
%------------------------------------------------------
handles.flag_Create_Tab = 1; % record the tab has already been created for next time the button is pushed

% update tab
[ParamTabUD ParamTabUDtxt Cond]=UpdateTabs(ParamTabUD,handles);

% Save
handles.ParamTabUDtxt = ParamTabUDtxt;
handles.ParamTabUD = ParamTabUD;
handles.Cond = Cond;

set(handles.figure1,'color',[.94 .94 .94])
drawnow
guidata(hObject, handles);


% --- Executes on button press in Print.
function Print_Callback(hObject, eventdata, handles)
% Pushing the EXPORT button you just display the export menu
handles=guidata(hObject);
set(handles.uitable1,'Visible','off')
set(handles.DispFoldExport,'String',[pwd '/ExpList'])

STX={'HELP' ...
    'You can select the Experiments you want' ...
    'to save directly from the Exp list using the'...
    'mouse right button and the SHIFT button for '...
    'multiple selections'... 
    'If you want to select all experimetns click on SELECT ALL'};
set(handles.Support,'String',STX)


guidata(hObject, handles);



% --- Executes on button press in Update_Database.
function Update_Database_Callback(hObject, eventdata, handles)
aa = questdlg(['You are about to update the internal .log files database. '...
    'This operation can take several minutes. Are you sure you want to continue?'])
if strcmp(aa,'Yes')
set(handles.figure1,'color',[1 .5 .5])

 %- info --
STX={ 'YOU ARE UPDATING THE INTERNAL .log FILES DATABASE. PLEASE WAIT... '};
set(handles.Support,'String',STX)
tic
% ----

% Select /data folder
DataDir = uigetdir(pwd);
 %- info --
STX={ 'YOU ARE UPDATING THE INTERNAL .log FILES DATABASE. PLEASE WAIT... ' ...
    '' ...
    'Data folder selected: ' DataDir};
set(handles.Support,'String',STX)

tic
% ----
MyDataFolder=handles.MyDataFolder;
%%% Import all .log files  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 % [goood, baad]= ImportLogFiles(DataDir,MyDataFolder,handles);
[changed , notchanged] =CreateLogFilesAddressLists(DataDir,MyDataFolder,handles);
 
 STX={'' ...
     [num2str(size(changed,2)) ' Lists have been successfully created/updated:'] ...
     changed{:} ...
     '' ...
     'The following Lists have NOT been updated : ' ....
     notchanged{:}};
      set(handles.Support,'String',STX)
           % ----------

%%% Create Monkey protocols files %%%%%%%%%%%%%%%%%%%%
TempoDataSummary(MyDataFolder);


%%% Create Protocols parameters list %%%%%%%%%%%%%%%%%%%%
CreateProtocolSummary(MyDataFolder);


% disaply and save last update date 
Last_Update= date
set(handles.LastUD,'String',['Last UPDATE ' Last_Update])
save('Last_Update','Last_Update')

durr = toc;
STX={ 'THE DATABASE HAS BEEN SUCCEFFULLY UPDATED!!' ...
    '' ...
   [ 'The process took ' num2str(durr,2) ' seconds' ] ...
   '' ...
   'the "Last Update" date on the top-right corner of the menu has been updated with today date '};
set(handles.Support,'String',STX)

% Update the menu
[MonkName, ProtNames,MN] = initGUI;

% Set
set(handles.MonkeyName,'String', ['Show_All' MonkName],'max',size(MN,2));
set(handles.Protocol,'String', ['Show_All' ProtNames],'max',size(MN,2));
load Last_Update
set(handles.LastUD,'String',['Last UPDATE ' Last_Update])

% info ------
STX=['HELP'  char(10) 'To start you have 2 options: ' char(10)... 
    ' 1. Select one or more Monkey names on the top left listbox' char(10)  ' 2. Select one Protocol on the listbox beside that' ...
    char (10)  char(10)'];

set(handles.Support,'String',STX)
% ----------

% Save
handles.MonkNameAll = ['Show_All' MonkName]';
handles.ProtName = ['Show_All'  ProtNames]';

handles.Selected_Monkeys = ['Show_All' MonkName]';
handles.Selected_Protocols = ['Show_All' ; ProtNames'];
handles.FlagProtSelection=0;
handles.flag_Create_Tab = 0;
handles.MyDataFolder = MyDataFolder;
guidata(hObject, handles);

else
 %- info --
STX={ '' ...
    'YOU HAVE CANCELED THE DATABASE UPDATE '};
set(handles.Support,'String',STX)
% ----   
 


end
set(handles.figure1,'color',[.94 .94 .94]);

% --- Executes on button press in ResetTab.
function ResetTab_Callback(hObject, eventdata, handles)
set(handles.figure1,'color',[1 .5 .5])
drawnow
ParamTabUD = handles.ParamTab; 
[ParamTabUD ParamTabUDtxt Cond]=UpdateTabs(ParamTabUD,handles);
handles.ParamTabUDtxt = ParamTabUDtxt;
handles.ParamTabUD = ParamTabUD;
handles.Cond = Cond; 
handles.SelectedExperimentsID =[];

%- info --
STX={ 'YOU HAVE RESET YOUR RESEARCH IN THE TAB!!!' ...
    '----------------'  ...
    'HELP'  ...
    'In the top rigth table you can select one or' ...
    'more parameters from the Options' ...
    'column (#2) writing them separete by a ' ...
    'comma within the Selection column (#3)' ...
    '(replacing the "All") ' ...
    ' ' ...
    'If you click on a field of the Option column' ...
    'you will see here the full content' ...
    ' ' ...
    'To RESET click on the monkey names on' ...
    'the top left listbox and on the UPDATE button again '};

set(handles.Support,'String',STX)
% ----
handles.Msg = '';

guidata(hObject, handles);
drawnow
set(handles.figure1,'color',[.94 .94 .94])  
 
 


% --- Executes when entered data in editable cell(s) in uitable1.
function uitable1_CellEditCallback(hObject, eventdata, handles)
% hObject    handle to uitable1 (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)
          


% --- Executes when selected cell(s) is changed in uitable1.
function uitable1_CellSelectionCallback(hObject, eventdata, handles)
% hObject    handle to uitable1 (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
%	Indices: row and column indices of the cell(s) currently selecteds
% handles    structure with handles and user data (see GUIDATA)
Cond=handles.Cond;
tm = eventdata.Indices;
if ~isempty(tm)
Col= tm(2);

if Col ==2
CellID =  tm(1);

 STX={ 'Display the full content of the Option column:' ...
     Cond{CellID}};

set(handles.Support,'String',STX)   
end
    
end



function DispFoldExport_Callback(hObject, eventdata, handles)
% hObject    handle to DispFoldExport (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of DispFoldExport as text
%        str2double(get(hObject,'String')) returns contents of DispFoldExport as a double


% --- Executes during object creation, after setting all properties.
function DispFoldExport_CreateFcn(hObject, eventdata, handles)
% hObject    handle to DispFoldExport (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in BrowseFoldExport.
function BrowseFoldExport_Callback(hObject, eventdata, handles)
handles=guidata(hObject);
EF = uigetdir(pwd);
set(handles.DispFoldExport,'String',[EF '/ExpList'])
guidata(hObject, handles);


% --- Executes on button press in ExpTabMat.
function ExpTabMat_Callback(hObject, eventdata, handles)
handles=guidata(hObject);
tm = get(handles.DispFoldExport,'String');
if isempty(handles.SelectedExperimentsID)
    errordlg(['You must select one or more experiments to save: Select the ' ...
        'experiments from the EXP LIST with the mouse or click on the Select all Exp button '])
    error(['You must select one or more experiments to save: Select the ' ...
        'experiments from the table with the mouse or click on the Select all Exp button '])
end
SelID = handles.SelectedExperimentsID;
T = handles.ParamTabUD(1,SelID); 
T2=struct2table(T);


Answ = questdlg(['Save as :  ' tm '.mat'])
if strcmp(Answ,'Yes')
save([tm '.mat'],'T2');
% ---info -------------
STX={'HELP' ...
    'Congratulations, the experiments list' ...
    'has been saved as a .mat file'};
set(handles.Support,'String',STX)
else
 STX={'HELP' ...
    'You did NOT saved the File'};
set(handles.Support,'String',STX)   
end
%-------------------


% --- Executes on button press in pushbutton10.
function pushbutton10_Callback(hObject, eventdata, handles)
% EXPORT to Excel
rispos = questdlg('This function is available only on PC where Excel is installed. Do you want to continue?');
if strcmp(rispos,'Yes')
handles=guidata(hObject);
tm = get(handles.DispFoldExport,'String');
T = handles.ParamTabUDtxt; 
T3=table2cell(T);
xlswrite([tm '.xls'],T3);
% ---info -------------
STX={'Congratulations, the experiments list' ...
    'has been saved as a .xls file'};
set(handles.Support,'String',STX)
%-------------------
end

% --- Executes on button press in BackToTable.
function BackToTable_Callback(hObject, eventdata, handles)
set(handles.uitable1,'Visible','on')




% --- Executes when selected cell(s) is changed in uitable2.
function uitable2_CellSelectionCallback(hObject, eventdata, handles)
handles=guidata(hObject);
handles.SelectedExperimentsID = eventdata.Indices(:,1)
t = handles.SelectedExperimentsID;
SelList =  handles.ParamTabUDtxt{t,1};
% ---info -------------
STX={'Manually selected experiments' ...
    '' ...
   SelList{:}};
set(handles.Support,'String',STX)
%-------------------
guidata(hObject, handles);


% --- Executes on button press in SelectAllExp.
function SelectAllExp_Callback(hObject, eventdata, handles)
handles=guidata(hObject);
m = size(handles.ParamTabUDtxt,1);
handles.SelectedExperimentsID = 1:m;
t = handles.SelectedExperimentsID;
SelList =  handles.ParamTabUDtxt{t,1};
% ---info -------------
STX={'Manually selected experiments' ...
    '' ...
   SelList{:}};
set(handles.Support,'String',STX);
%-------------------
guidata(hObject, handles);
