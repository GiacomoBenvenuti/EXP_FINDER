function [changed , notchanged] = CreateLogFilesAddressLists(DataDir,MyDataFolder,handles)
% Find all log files in the Data folder and create a list of files adresses
% for each folder/monkey
notchanged{1} = 'none';
changed{1}='none';
FF = dir(DataDir);
ctg = 0; % counters
ctb=0;
for i =1:size(FF,1) % go through all subfolders (MonkeyNames)
    if isempty(strfind(FF(i).name,'.'))
    %     if numel(FF(i).name)>3
        ffn =FF(i).name;
        flag = 1;
        % create a backup file if a list already exist
        if exist([MyDataFolder filesep ffn 'LogAddress.mat'])
            % info
            STX={' Please check popup dialog to continue. '};
            set(handles.Support,'String',STX)
            
            a =questdlg([' An Experiments list for ' ffn ' already exists, do you want to create a new one (is there any new experiment)?'])
           pause(.5)
            if strcmp(a,'Yes')
                load([MyDataFolder filesep ffn 'LogAddress.mat']);
                save ([MyDataFolder filesep ffn 'LogAddressBK.mat'],'LogAddress');
                
                STX={[ffn ' Experiments List will be Updated. ' ]...
                    '' ...
                    'A backup file of the old List has been generated'  };
                set(handles.Support,'String',STX)
                
            else
                
                STX={ffn ' Experiments List will NOT be Updated. '};
                set(handles.Support,'String',STX)
                flag = 0;
                ctb=ctb+1;
                notchanged{ctb} =[ffn  'LogAddress.mat'];
            end
        end
        
        if flag ==1 %
            
            % Check if filename address exist in the adressess file, if not copy it
            
            % find all log files in the current folder and subfolders
            L1=[]; L2=[]; L3=[];
            try
             ff= ls([DataDir  filesep FF(i).name filesep '*.log'],'-1' )
            L1 =strsplit(ff);
            end
            try
            ff= ls([DataDir  filesep FF(i).name filesep '**' filesep '*.log'],'-1' )
            L2 =strsplit(ff);
            end
            try
            ff= ls([DataDir  filesep FF(i).name filesep '**' filesep  '**' filesep '*.log'],'-1' )
            L3 =strsplit(ff);
            end
            
            try 
             LogAddress =cat(2,L1,L2,L3);

%             clear   LogAddress
%             for y = 1:size(tm,2)
%                 LogFileID = tm{y};
%                 %  FileMatch = strfind(LogAddress, LogFileID); % check if the logfile address is already in the list
%                 LogAddress{y} = LogFileID;
%             end  % folder is good
            
            save([MyDataFolder filesep ffn  'LogAddress.mat'], 'LogAddress');
            ctg=ctg+1;
            changed{ctg} =[ffn  'LogAddress.mat'];
            end
        end % folders
        
    end
end