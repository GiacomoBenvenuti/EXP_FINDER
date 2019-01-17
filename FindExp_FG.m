function FindExp_FG
% TODO
% MENU 1
% select monkeys and combine data




MF_GUI(t)
end


function MF_GUI(t)
% make a GUI Table with all the input
% Add all input to the table t
%------------------------------------
clear tc out fn
%fn= t.Properties.VariableNames;
fn=fieldnames(t);
tc(1,:) = fn;
tc(2,:)=struct2cell(t)
ui1=figure(20)
ui1.Name='MAKE_FIG MENU';
ui1.NumberTitle= 'off';
ui1.Color=[.7 .9 .9]
clf
ui1.Units='normalized'
ui1.Position=[ 0.7001    0.1523    0.5205    0.5977];
t1 = uitable(ui1,'Data',tc','ColumnWidth', {150 450})
t1.Units='normalized';
t1.ColumnEditable=true;
t1.Position=[.05  .2   0.9    0.75]
for i = 1:numel(fn)
    eval (['t.' fn{i} '= t1.Data{i,2}']);
end

btn = uicontrol('Style', 'pushbutton', 'String', 'UPDATE',...
    'Callback',  @(src,event)UPD(t1),'Units','normalized','Position',[0.0494    0.0552    0.1 0.1],...
    'BackgroundColor','green');
disp('push button to continue')

btnMF1 = uicontrol('Style', 'pushbutton', 'String', 'MAKE_FIG1',...
    'Callback',  @(src,event)MAKE_FIG.MAKE_FIG1 ,'Units','normalized','Position',[0.3    0.0552    0.15 0.1],...
    'BackgroundColor','yellow');

btnMF2 = uicontrol('Style', 'pushbutton', 'String', 'MAKE_FIG2',...
    'Callback',  @(src,event)MAKE_FIG.MAKE_FIG2 ,'Units','normalized','Position',[0.5    0.0552    0.15 0.1],...
    'BackgroundColor','red');
disp('push button to continue')

save_all = uicontrol('Style', 'pushbutton', 'String', 'PRINT',...
    'Callback',  @(src,event)PRINT ,'Units','normalized','Position',[0.7    0.0552    0.15 0.1],...
    'BackgroundColor','blue');
disp('push button to continue')

end


function UPD(t1)
disp('UPDATE!!')
fn=t1.Data(:,1);
dat=t1.Data(:,2);
for i=1:numel(fn)
    eval(['t2.' fn{i} '=  dat{i}']); 
end

UpDate(t2)
t2
save([pwd '/data/t1'],'t1');
end

function UPDATE_DB
% when you add log files to the monkey folders 
% you can update the database structures 
EXP_FINDER.TempoDataSummary;
EXP_FINDER.CreateProtocolSummary(1);
end


function PRINT

 load([pwd '/data/t1'])
% if t2.Rec_cond == 3
%     c1=1;
% elseif t2.Rec_cond == 8
%     c1=2;
% elseif t2.recenter_DT==1
%     c1=3;
% end
h= waitbar(0,'Please wait...');

[f P] = uiputfile('/+MAKE_FIG/data/3T_','Save file name');
fnFigRoot =[P f]
fnPS = [fnFigRoot,'.ps'];
    fnPDF = [fnFigRoot,'.pdf'];
hgfFig = figure;

set(gcf,'color','w', 'Units','centimeters', 'Position',[28   -1.5   21 27],...
    'Paperpositionmode','auto');
a=t1.Data;
n=size(a,1)
for i=1:n
annotation('textbox',[.1  .8-(.75/n*i) .3 .1], 'String', a(i,1),...
    'FontSize',10, 'linestyle','none','Interpreter', 'none');
annotation('textbox',[.45  .8-(.75/n*i) .5 .1], 'String', a(i,2),...
    'FontSize',10, 'linestyle','none','Interpreter', 'none');
end


print(hgfFig,fnPS,'-dpsc2');
waitbar(.2, 'saving fig1')

figure(2001)
print(gcf,fnPS,'-dpsc2','-append');
waitbar(.4, 'saving fig2')

figure(2002)
print(gcf,fnPS,'-dpsc2','-append');
 waitbar(.6, 'converting to pdf') 
 
MAKE_FIG.tools.ps2pdf('psfile',fnPS,'pdffile',fnPDF,'deletepsfile', 0);
close(h)

end