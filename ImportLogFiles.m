function [goood , baad]=ImportLogFiles(DataDir,MyDataFolder,handles)
% Import .log file from DataDir to MyDataFolder
FF = dir(DataDir);
goood = nan;
baad=nan;
  ctg = 0; % counters
   ctb=0;
for i =1:size(FF,1) % go through all subfolders
    if numel(FF(i).name)>3 
    % if the folder name does not exist in the DATABASE 
    % create one 
       ffn =FF(i).name;
       if ~exist([MyDataFolder filesep ffn])
           
           % info ------
           myfold = dir(MyDataFolder);
           a={myfold.name};
           b = strfind([myfold.isdir],1);
           xx = {a{b}};
            c= strfind (xx,'PRT');
            ct = 0 ;
            for q = 1:size(c,2)
               if isempty(c{q})
                   if numel( xx{q} )>2
                ct=ct+1;
                QQ{ct} = xx{q} 
                   end
               end
            end
            
           STX={'Folders within the internal DATABASE : ' ...
               '' ...
               a{b}  };
           
           set(handles.Support,'String',STX)
           % ----------
           
          aa = questdlg(['Folder ' ffn ' does not exist in the internal DATABASE. ' ...
               'Be sure this is not just a different name for one of the folders that already exist in the internal database.' ...
               'Compare this name with the existing folders name in the Support panel. ' ...
               'If you find this folder, i.e. "BartXX" is the same that "Bart" change the folder name in /data. ' ...
               'Should I create one?'])
           
           if strcmp(aa,'Yes')
           mkdir([MyDataFolder filesep ffn]);
           else
               error('PLEASE CHANGE THE FOLDER NAME FROM THE SOURCE FOLDER AND TRY AGAIN')
           end               
       end
       
       % Check in a filename exist in the folder if not copy it 
       
       % find all log files in the current folder 
       tm= dir([DataDir  filesep FF(i).name filesep '*log'] )
     
       for y = 1:size(tm,1)
           destt = [MyDataFolder filesep ffn filesep tm(y).name];
           if ~exist(destt)
              succ = copyfile([DataDir  filesep FF(i).name filesep tm(y).name],destt) ;
              if succ ==1
                  ctg=ctg+ctg;
                  goood{gtc} =tm(y).name;
              else
                  ctb=ctb+ctb;
                  baad{ctb} =tm(y).name;
                  
              end
              
           end
       end
    
    end  % folder is good
end % folders

end