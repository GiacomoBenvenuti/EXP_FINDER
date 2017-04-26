function TempoDataSummary(DataFolder)
% TempoDataSummary(DataFolder)
% Find .log files within the DATABASE internal folder
% and create a .mat file for every monkey MonkNamePList.
% This file is a structure containing all the protocols available for that
% monkey. Within evvery protocol are stored the exp names
% by GB 2017


% Find Mokeyname from folders names
clear MonkName
myfold = dir(DataFolder);
a={myfold.name};
b = strfind([myfold.isdir],1);
xx = {a{b}};
c= strfind (xx,'PRT');
ct = 0 ;
for q = 1:size(c,2)
    if isempty(c{q})
        if numel( xx{q} )>2
            ct=ct+1;
            MonkName{ct} = xx{q}
        end
    end
end

            
            
for Monk =1:size(MonkName,2)
    
    clear pathh
    pathh = [DataFolder filesep MonkName{Monk} filesep];
    fn1 = dir([pathh '**']); % Load all data name
    fn = {fn1.name};
    bb(1)=find(strcmp(fn,'.')==1);
    bb(2)=find(strcmp(fn,'..')==1);
    fn(bb(:)) =[];
   % eval(['clear ' MonkName{Monk}]);
    
    
    % MONKEY PROTOCOLS SUMMARY
    % go through all experiment and generate a structure var
    % with a field for each protocol and the list of blocks id
    clear AllProt
    ctt=0;
    for i =1:size(fn,2) % go through all experiments
        clear A tm
        if isempty(strfind(fn{i}(1),'.'))
          ctt=ctt+1;
        A = fileread([pathh  fn{i}]);
        tstart = strfind(A,'ProtocolName=') + numel('ProtocolName=')+1;
        tend = strfind(A(tstart:tstart+50),'''') + tstart-2;
        
        AllProt{ctt} = A(tstart:tend);
        end
    end
    
    [AP x APN]= unique(AllProt);
    clear Plist
    
    for i = 1:size(AP,2)
        clear tmp tmp2
        AP{i}(isspace(AP{i}))=[];
        AP{i}(strfind(AP{i},'-'))=[];
        tmp = find(APN==i);
        if size(tmp,1) >1
            tmp2 = tmp';
        else
            tmp2=tmp;
        end
        if ~isempty(AP{i})
            eval(['Plist.' AP{i} ' = {fn{tmp2}}']);
        end
    end
    
    eval([MonkName{Monk} 'PList= Plist']);
    
    save([DataFolder filesep...
        MonkName{Monk} 'PList'], [MonkName{Monk} 'PList'] )
end

end


