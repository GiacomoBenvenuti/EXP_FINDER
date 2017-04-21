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
STX=['HELP'  char(10) 'To start you have 2 options: ' char(10)... 
    ' 1. Select one or more Monkey names on the top left listbox' char(10)  ' 2. Select one Protocol on the listbox beside that' ...
    char (10)  char(10) '    ------------------- ' char(10) 'Database last update 6/10/2016'];

set(handles.Support,'String',STX)
% ----------

% Save
handles.MonkNameAll = ['Show_All' MonkName]';
handles.ProtName = ['Show_All'  ProtNames]';

handles.Selected_Monkeys = ['Show_All' MonkName]';
handles.Selected_Protocols = ['Show_All' ; ProtNames'];
handles.FlagProtSelection=0;
handles.flag_Create_Tab = 0;
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
    
    set(handles.Protocol,'String', ProtNames','max',size(MNtmp,2));
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
s= what(['DATABASE'])
cd(s.path);

% LOAD
handles=guidata(hObject);
SMK=handles.Selected_Monkeys; % use the custum monkey selection
Sel_Prot=handles.Selected_Protocols ;
ProtName=handles.ProtName;
MNtmp=handles.MonkNameAll;
%MN =MNtmp(2:end);

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
        ts = strfind(tm , PNs)
        if ~isempty(ts)
            ct=ct+1;
            MNP{ct} = tm(1:ts-1);
        end
        
    end
    
    NewMonkSel=find(ismember(MNP,SMK)==1)
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
handles=guidata(hObject);

set(handles.figure1,'color',[1 .5 .5])

flagUD = handles.flag_Create_Tab;

Sel_PRT = handles.Selected_Protocols;
MM = handles.Selected_Monkeys;
tm = get(handles.MonkeyName,'Value');
Sel_Monk ={ MM{tm}};

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
    'To RESET click on the monkey names on' ...
    'the top left listbox and on the UPDATE button again '});

set(handles.Support,'String',STX)
%-----------------

% PROCESS
% CreateParamTab
sp=what(['PRT_' Sel_PRT{2}]);

clear L
for i = 1:size(Sel_Monk,2)
    tm = [Sel_Monk{i} Sel_PRT{2}];
    load([sp.path '/' tm])
    eval(['mm{i} = ' tm]);
    s = size(mm{1},2);
    fn{i} =fieldnames(mm{i});
    nf(i)=size( fn{i},1);
    txx = [' mm{' num2str(i) '}']
    L(1,(1:numel(txx))+(numel(txx)*(i-1) ) ) = txx ;
end

% Check if struct diff monkeys have the same num of fields!
if ~(sum(nf)==nf(1)*(numel(nf))) 
d = questdlg(['The number of parameters ' ...
    'is not the same for all monkeys!' char(10) ...
    '[' num2str(nf) ']. Do you want to continue anyway?'] )

if  strcmp(d, 'Yes') == 1
 %  errordlg('I still have to do this part :) ','Different param number');  
   [a b] = max(nf(:)) ;
   LessP = find(nf<a);
     
   DiffParamInd =  fn{b}(find(ismember(fn{b}, fn{ LessP(1) }) ==0));
  
   for i = 1:numel(LessP)
       for y = 1: numel(DiffParamInd )
           for q =1:size(mm{LessP(i)},2)
        eval([' mm{LessP(i)}(1,q).' DiffParamInd{y} ' = nan']);
       end
   end
   end
  
   % use fn
else
    errordlg('Select a new group of Monkeys!','Different param number');
   
end
end

eval(['ParamTab = [' L ']' ]);% full Tab 

ParamTabUD = ParamTab;  % ParamTabUD is the one that will be updated
handles.ParamTab = ParamTab;
handles.ParamTabUD = ParamTabUD;
handles.Msg{1} = '  ';
else %-----------------------------------------------
    %--------------------------------------------------
    
% PARAMETERS TAB USER INPUT    
% If user change tab field 'Select' update the Tab
ParamTabUD=handles.ParamTabUD;
Condx = handles.Cond;
Msg = handles.Msg;

%GET
TabModif = get(handles.uitable1,'Data');
FieldCol =  TabModif(:,1);
SelCol=[{TabModif{:,3}}];
[a s1 ] = find(strcmp('All',SelCol) ==0);
if numel(s1)>0 % go on only if user modified the Tab
InpField = FieldCol(s1);

for i =1:numel(s1)
CondSel{i} = str2num(Condx{s1(i)}) ; 

InpVal{i} =  str2num(cell2mat(SelCol(s1(i))));

MTCH{i} = isempty(intersect(CondSel{i},InpVal{i}));
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
    

ParamTabUD = ParamTabUD(SelExpInd);
handles.ParamTabUD = ParamTabUD;

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
    'To RESET click on the monkey names on' ...
    'the top left listbox and on the UPDATE button again '};

set(handles.Support,'String',STX)
%-----------------

handles.Msg = Msg;

end  % List of exceptions
end
end
end % only first time --------------------------------------
%------------------------------------------------------
handles.flag_Create_Tab = 1; % record the tab has already been created for next time the button is pushed

% Generate Selection tab
ParamNames = fieldnames(ParamTabUD);
clear Cond SelTab
for i = 1: size(ParamNames,1 )
    Cond{i} =nan;
 try   
     tm =num2str([ unique([ParamTabUD.(ParamNames{i})])   ]) ;
      Cond{i} =(tm);
 end
    SelTab{i} ='All' ;
end

T = table(ParamNames, Cond',SelTab');
% SET
set(handles.uitable1,'Data',T{:,:} ,'ColumnName',{'Param' , 'Options', 'Select' }, ...
    'ColumnEditable',[false false true],'ColumnWidth',{150 250 140});

% Convert all field to str to display in uitable2
clear tm aramStructtxt
for i = 1:size(ParamTabUD,2)
   for y  = 1: size(ParamNames,1 ) 
       tm = num2str([ ParamTabUD(i).(ParamNames{y})  ]);
       if size(tm,1)>1
           tm=tm(:)';
       end
       ParamStructtxt(i).(ParamNames{y})  = tm;
     clear ss1
     ss1= numel(tm)*50;
     ss1(find(ss1>150)) =150;
     ss{y} = ss1;
   end
end

ParamTabUDtxt=struct2table( ParamStructtxt);

set(handles.uitable2,'Data',ParamTabUDtxt{:,:} ,'ColumnName',  {ParamNames{:}}, 'ColumnWidth',{ss{:}} );
set(handles.figure1,'color',[.94 .94 .94])

handles.ParamTabUDtxt = ParamTabUDtxt;
handles.ParamTabUD = ParamTabUD;
handles.Cond = Cond;
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
