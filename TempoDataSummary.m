function TempoDataSummary(DataFolder)
% TempoDataSummary(DataFolder)
% Find .log files within the DATABASE internal folder
% and create a .mat file for every monkey MonkNamePList.
% This file is a structure containing all the protocols available for that
% monkey. Within evvery protocol are stored the exp names
% by GB 2017


% Find Mokeyname from folders names
myfold = dir([DataFolder filesep '*LogAddress.mat']);
a={myfold.name};
           
            
for i =1:size(a,2)
    
load([DataFolder filesep a{i}])
fn = LogAddress;
    
    % MONKEY PROTOCOLS SUMMARY
    % go through all experiment and generate a structure var
    % with a field for each protocol and the list of blocks id
    clear AllProt
    ctt=0;
    for y =1:size(fn,2) % go through all experiments
        clear A tm
        if isempty(strfind(fn{y}(1),'.'))
         ctt=ctt+1;
        A = fileread( fn{y});
        tstart = strfind(A,'ProtocolName=') + numel('ProtocolName=')+1;
        tend = strfind(A(tstart:tstart+50),'''') + tstart-2;
        
        AllProt{ctt} = A(tstart:tend);
        end
    end
    
    clear AP
    [AP x APN]= unique(AllProt);
    clear Plist
    
    for y = 1:size(AP,2)
        clear tmp tmp2
        AP{y}(isspace(AP{y}))=[];
        AP{y}(strfind(AP{y},'-'))=[];
        tmp = find(APN==y);
        if size(tmp,1) >1
            tmp2 = tmp';
        else
            tmp2=tmp;
        end
        if ~isempty(AP{y})
            eval(['Plist.' AP{y} ' = {fn{tmp2}}']);
        end
    end
    
    tm = size(a{i},2);
    MonkName = a{i}(1:tm-14);  
    eval([MonkName 'PList= Plist']);
    
    save([DataFolder filesep...
        MonkName 'PList'], [MonkName 'PList'] )
end

end


