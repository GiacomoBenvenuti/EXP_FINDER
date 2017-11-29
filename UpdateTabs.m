function [ParamTabUD ParamTabUDtxt Cond]=UpdateTabs(ParamTabUD,handles);
% [ParamTabUD ParamTabUDtxt Cond]=UpdateTabs(ParamTabUD,handles);
%  After the user specified some parameter value in the PARAM LIST (EF_GUI), this script takes the current 
%  EXP LIST, filter the experiments matching with that parameter values and generate a new 
%  PARAM LIST based on the remaining experiments. The EXP list is resetted pushing the 
%  RESET TAB function or Show All in the monekeys and protocols lists. 
% 
% ParamTabUDtxt : is a version of the PARAM LIST where all values are text.
% you need this to display the param values in the PARAM LIST GUI (uitable)
% by GB 2017

% Generate Selection tab
ParamNames = fieldnames(ParamTabUD);
clear Cond SelTab
for i = 1: size(ParamNames,1 )
       Cond{i} =nan;

       q=1;
       while isempty(ParamTabUD(q).(ParamNames{i})) | isnan(ParamTabUD(q).(ParamNames{i}))  & q<size(ParamTabUD,2)
           q = q+1;
       end
    
     % if Param field contains 2 values categories (i.e. x,y. coordinats) save as conplex num
     if size(ParamTabUD(q).(ParamNames{i}),1) >1 
         clear pp
         for k = 1:size(ParamTabUD,2)
             if ~isempty(ParamTabUD(k).(ParamNames{i})) & ~isnan(ParamTabUD(k).(ParamNames{i})(1,:))
              
              pp{k} = num2str(unique(complex(ParamTabUD(k).(ParamNames{i})(1,:),  ParamTabUD(k).(ParamNames{i})(2,:))));
             else
               pp{k} = 'None';  
             end   
        end 
              tm = [unique(pp)];
     
     else % single value
         
           clear pp
         for k = 1:size(ParamTabUD,2)
             if ~isempty(ParamTabUD(k).(ParamNames{i})) & ~isnan(ParamTabUD(k).(ParamNames{i}))
                
                                   
                pp{k} = [num2str((ParamTabUD(k).(ParamNames{i}))) ' '];
             else
               pp{k} = 'None';  
             end   
         end 
         
         if sum(isspace(pp{1})) ==1
             tm = unique(pp) ;
         else
             pp = setdiff(pp,'None');
            if ~isempty(pp)
             
             ff = cat(2,pp{:}) ;
             ff2 =strsplit(ff);
             ff2 = setdiff(ff2,'');
             tm = unique( ff2  ); % unique(  [pp{:} ] )    ;
            
             
             for j = 1:size(tm,2)
                 tm{j} = [tm{j} ' ' ]  ;
             end
             
             else
                tm = 'None';
            end
             
         end
         end
     
     
         
              %tm = [unique(pp)];
         %    if  isstr(ParamTabUD(q).(ParamNames{i})  )
%         else
%            tm =num2str([ unique(  [pp]  )   ]) ;
%         end
%         if  isstr(ParamTabUD(q).(ParamNames{i})  )
%               tm =[ unique(  {ParamTabUD.(ParamNames{i})}  )   ] ;
%         else
%            tm =num2str([ unique(  [ParamTabUD.(ParamNames{i})]  )   ]) ;
%         end
    % tm =num2str([ unique([ParamTabUD.(ParamNames{i})])   ]) ;
     
    
     
     if iscell(tm)
      Cond{i} =[tm{:}];
     else
       Cond{i} =tm;    
     end
      
  
    SelTab{i} ='All' ;
end

T = table(ParamNames, Cond',SelTab');
% SET Param list/table
set(handles.uitable1,'Data',T{:,:} ,'ColumnName',{'Param' , 'Options', 'Select' }, ...
    'ColumnEditable',[false false true],'ColumnWidth',{150 250 140});

% Convert all field to str to display in uitable2handles.ParamTabUDtxt = ParamTabUDtxt;
handles.ParamTabUD = ParamTabUD;
handles.Cond = Cond;
clear tm aramStructtxt
for i = 1:size(ParamTabUD,2)
   for y  = 1: size(ParamNames,1 ) 
       % convert to text to be displayed
       tm = num2str([ ParamTabUD(i).(ParamNames{y})  ]); 
       if size(tm,1)>1
           tm=tm(:)';
       end
     ParamStructtxt(1,i).(ParamNames{y})  = {tm};
     clear ss1
     ss1= numel(tm)*50;
     ss1(find(ss1>150)) =150;
     ss{y} = ss1;
   end
end

ParamTabUDtxt=struct2table( ParamStructtxt(:));

set(handles.uitable2,'Data', ParamTabUDtxt{:, :}  ,'ColumnName',  {ParamNames{:}}, 'ColumnWidth',{ss{:}} );




end