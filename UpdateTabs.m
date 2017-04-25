function [ParamTabUD ParamTabUDtxt Cond]=UpdateTabs(ParamTabUD,handles);
% Update the two tabs in EXPERIMET FINDER GUI
% by GB
% Generate Selection tab
ParamNames = fieldnames(ParamTabUD);
clear Cond SelTab
for i = 1: size(ParamNames,1 )
    Cond{i} =nan;

     
     if size(ParamTabUD(1).(ParamNames{i}),1) >1
         clear pp
         for k = 1:size(ParamTabUD,2)
              pp{k} = num2str(unique(complex(ParamTabUD(k).(ParamNames{i})(1,:),  ParamTabUD(k).(ParamNames{i})(2,:))));
         end 
              tm = [unique(pp)];
       else
     
        if  isstr(ParamTabUD(1).(ParamNames{i})  )
              tm =[ unique(  {ParamTabUD.(ParamNames{i})}  )   ] ;
        else
          tm =num2str([ unique(  [ParamTabUD.(ParamNames{i})]  )   ]) ;
        end
    % tm =num2str([ unique([ParamTabUD.(ParamNames{i})])   ]) ;
     
     end
     
     if iscell(tm)
      Cond{i} =[tm{:}];
     else
       Cond{i} =tm;    
     end
      
 
    SelTab{i} ='All' ;
end

T = table(ParamNames, Cond',SelTab');
% SET
set(handles.uitable1,'Data',T{:,:} ,'ColumnName',{'Param' , 'Options', 'Select' }, ...
    'ColumnEditable',[false false true],'ColumnWidth',{150 250 140});

% Convert all field to str to display in uitable2handles.ParamTabUDtxt = ParamTabUDtxt;
handles.ParamTabUD = ParamTabUD;
handles.Cond = Cond;
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




end