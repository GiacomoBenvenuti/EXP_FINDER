# Experiment Finder 
By Giacomo Benvenuti, PhD
Eyal Seidemann Lab at the University of Texas at Austin,USA

QUICK START
————————
This app allows you to:  
1. generate a database of experiments meta-data from the log files created by Tempo software. 
2. Generate a table of experiments-files-paths with a specific set of parameters
3. Allows you to use multiple advanced selection strategies to find the experiments with the parameters that you are looking for
4. Export this list as a Matlab or Excel table file. This table can be loaded directly to RunDA to run analysis on these experiments  

Run “RunEF.m”

<p align="center">
<img src="./Recording_DEMO_EXP_FINDER.gif" width="60%">
</p>

FOR DEVELOPERS
———————
Main File is “EF_GUI.m”


- Update message in the GUI dialog box 
%- info --
STX={ '' ...
    'YOU HAVE CANCELED THE DATABASE UPDATE '};
set(handles.Support,'String',STX)
% ----    
