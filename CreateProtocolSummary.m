function CreateProtocolSummary
% Generate the parameters matrixes for the protocol 
% foldert DATABSE/PRT_ProtocolName
% files BartFlashGratings.mat
% by GB

%  EXP_FINDER.CreateProtocolSummary
s=what('EXP_FINDER');
cd (s.path)
cd DATABASE

%------------------------------------------
wb = waitbar(0,'Create Paramers database. Please wait...');

% Generate monkey list
clear MN MN2  MonkName
MN= dir('*PList.mat');
MN2 = {MN.name};
for i = 1:size(MN2,2)
    tmp =MN2{i};
    tmp2=tmp(1:size(tmp,2)-9);
    MonkName{i} = tmp2;
end

clear PRT
for i = 1:size(MN2,2)
    load(MN2{i});
    nm = [MonkName{i} 'PList'];
    eval(['tm= fieldnames(' nm ')']);
    PRT{i}=tm;
end


for Monk =1:size(MN,1) % select monkey based on MonkName
       waitbar(Monk/size(MonkName,2))
    for p=1: size(PRT{Monk},1)
        
        if exist(['PRT_'  PRT{Monk}{p}])==0
            mkdir(['PRT_'  PRT{Monk}{p}]);
        end
    
        
        load([  MonkName{Monk} 'PList.mat']); % Load all data name
        
        clear blkList
        MonkName{Monk} 
        eval (['f = fieldnames([' MonkName{Monk} 'PList])']);
        f2 = strfind(f,PRT{Monk}{p});
        
        if cell2mat(f2)>0
            eval([ 'blkList = '  MonkName{Monk} 'PList.' PRT{Monk}{p}])
           
           
            
             ProtCategories = {'ExptInfo.', 'Conditions.'}
            clear monk
            for k =1:size(blkList,2)
              
                if ~isempty(blkList{k})
                clear A tm fns
              %  fns = [  MonkName{Monk} '/' blkList{k} '.log']  ;
                fns = [  MonkName{Monk} '/' blkList{k} ]  ;
                tm = find(isspace(fns)==1,1)-1; % Some paths have a space at the end that must be removed
                if isempty(tm)
                    tm = size(fns,2);
                end
           
                A = fileread(fns(1,1:tm)); % load the log file to matlab
                
                monk(k).name = fns(1, tm-17:tm-4); % save the block name
                
                
                % -----
                % Find the initial point of all params fields
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
                    eval(['monk(k).' tmSTR ]) ;
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