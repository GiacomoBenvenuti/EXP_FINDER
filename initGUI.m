function [MonkName, ProtNames,MN] = initGUI
% Generate the total Monkeys and Protocols list (names/cell)
% by GB
MonkName=[];
ProtNames =[]; 
MN =[];
MN= dir('*PList.mat');
MN2 = {MN.name};
for i = 1:size(MN2,2)
    tmp =MN2{i};
    tmp2=tmp(1:size(tmp,2)-9);
    MonkName{i} = tmp2;
end
 
PRT= dir('PRT*');
tm = {PRT.name};
if ~ isempty(tm)
for i =1:size(tm,2)
    PR{i} = tm{i}(5:end);
end

ProtNames = PR;
end
end

