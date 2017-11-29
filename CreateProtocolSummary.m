function CreateProtocolSummary(MyDataFolder)
% Generate the parameters matrixes for the protocol 
% foldert DATABSE/PRT_ProtocolName
% files BartFlashGratings.mat
% by GB

%  EXP_FINDER.CreateProtocolSummary
% s=what('EXP_FINDER');
% cd (s.path)
cd(MyDataFolder)

%------------------------------------------
wb = waitbar(0,'Create Paramers database. Please wait...');

% Generate monkey list
clear MN MN2  MonkName
MN= dir('*PList.mat'); % there is one file like this for each monkey and contains all the protocols run with that monkey
MN2 = {MN.name};
for i = 1:size(MN2,2)
    tmp =MN2{i};
    tmp2=tmp(1:size(tmp,2)-9);
    MonkName{i} = tmp2;
end

% Create Protocols Lists : collect all experiments across monkeys for that
% protcol
clear PRT
for i = 1:size(MN2,2)
    load(MN2{i});
    nm = [MonkName{i} 'PList'];
    eval(['tm= fieldnames(' nm ')']);
    PRT{i}=tm;
end

myfold = dir( '*LogAddress.mat'); % For every monkey there is a file like this that contains all the address of its .log files
a={myfold.name};
           
for Monk =1:size(MN,1) % select monkey based on MonkName
       waitbar(Monk/size(MonkName,2))
       
      load(a{Monk})
      fn = LogAddress;
       
    for p=1: size(PRT{Monk},1)
        
        if exist(['PRT_'  PRT{Monk}{p}])==0
            mkdir(['PRT_'  PRT{Monk}{p}]);
        end
        load([  MonkName{Monk} 'PList.mat']); % Load all data name
        
        clear blkList
        % Check if the current Protocol was used for the current monkey
        MonkName{Monk} 
        eval (['f = fieldnames([' MonkName{Monk} 'PList])']);
        f2 = strfind(f,PRT{Monk}{p});
        
        % If this protocol was run in this monkey get the experiments
        % references
        if cell2mat(f2)>0
            
            % This are all the exp for this protocol run in this monkey
            eval([ 'blkList = '  MonkName{Monk} 'PList.' PRT{Monk}{p}]);
            
            % Get the param under those structures in the .log file
         %---------------------------------------------------------------------------- 
             ProtCategories = {'ExptInfo.', 'Conditions.'}; % this is something that could be cahnged by the user
        %----------------------------------------------------------------------------
            clear monk
            
            % Get param experiment by experiment
            for k =1:size(blkList,2)
              
                if ~isempty(blkList{k})
                clear A tm fns
              %  fns = [  MonkName{Monk} '/' blkList{k} '.log']  ;
                fns = blkList{k};%  [  MonkName{Monk} '/' blkList{k} ]  ;
                tm = find(isspace(fns)==1,1)-1; % Some paths have a space at the end that must be removed
                if isempty(tm)
                    tm = size(fns,2);
                end
                % Load the text from the .log file
                A = fileread(fns(1,1:tm)); 
                
                tm 
                fns
                in = find( fns(1, :) == filesep);
                 monk(k).name = fns(1, in(end)+1:tm-4); % save the block name
              %  monk(k).name = fns(1, tm-17:tm-4); % save the block name
                monk(k).PathLogFile = fns(1:in(end)-1);
                % -----
               
                % Find the initial point in the log file text of all params fields
                % you want to save
                clear tID
                for q = 1:numel(ProtCategories)
                  tx = strfind(A,ProtCategories{q});
                  tx(find(tx>15000)) = [];
                  if q==1
                  tID=tx;
                  else
                  tID(size(tID,2)+1:size(tID,2)+numel(tx)) =tx;   
                  end
                end
                
                for h = 1:numel(tID)
                    clear tm tmSTR
                   % tm = strfind(A(tID(h):tID(h)+100),A(tID(h) : tID(h)+5 ));
                     tm = strfind(A(tID(h):tID(h)+100),char(10) );
                 if  isempty(tm)
                     A(tID(h):tID(h)+100);
                 else
                  
                    tmSTR = A(tID(h) : tID(h)+tm(1)-1);
                    tmSTR(isspace(tmSTR))=[];
                    po = strfind(tmSTR,'.');
                    tmSTR(1:po) = [];
                    eval(['monk(k).' tmSTR ]) ; % tmSTR contain the filed name and the field value (e. i. Room=4)
                 end
                end
                end
            end
            
            eval([MonkName{Monk}  PRT{Monk}{p}  '= monk']); % rename the structure as the monkey
            clear monk
            
            save([  'PRT_' PRT{Monk}{p} '/' MonkName{Monk}  PRT{Monk}{p} ] ...
                ,[ MonkName{Monk}  PRT{Monk}{p} ])
        end
    end
    

end
  close(wb)
end