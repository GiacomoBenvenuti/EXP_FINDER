XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
XXXXXXX  EXPERIMENTS FINDER XXXXXXXXX
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

By Giacomo Benvenuti, PhD
Eyal Seidemann Lab at the University of Texas at Austin,USA

QUICK START
————————
This app allows you to:  
1. generate a database of experiments meta-data from the log files created by Tempo software. 
2. Generate a table of experiments-files-paths with a specific set of parameters
3. Export this list as a Matlab or Excel table file. This table can be loaded directly to RunDA to run analysis on these experiments  

Run “RunEF.m”



FOR DEVELOPERS
———————
Main File is “EF_GUI.m”


- Update message in the GUI dialog box 
%- info --
STX={ '' ...
    'YOU HAVE CANCELED THE DATABASE UPDATE '};
set(handles.Support,'String',STX)
% ----    