# Experiment Finder 
By Giacomo Benvenuti, PhD

Eyal Seidemann Lab at the University of Texas at Austin,USA

Over the years, the Seidemann Lab has run multiple experiments using many combinations of stimuli and brain imaging parameters. Imagine that you have an hypothesis that you want to test using a certain cobination of experimental conditions. It would be great if you could check if an experiment similar to the one you want to run has been already ran in the past. 

EXP_FINDER allows you to quickly see a summary of the experimental conditions run in the past and define multiple filters to find experiments with conditions similar enough to the one you need. 

**You just need to lounch the GUI and follow the suggestions from the interactive HELP windonw at the bottom left of the frame!**


<p align="center">
<img src="./Recording_DEMO_EXP_FINDER.gif" width="100%">
</p>

## Quick start
1. Clone this repository, open Matlab and click on EXP_FINDER_mlappinstall. This will add the louncher icon in the Matlab APP section. You just need to click on the icon to open the GUI and start your search. When you open the GUI just follow the directions in the bottom-left window! 
2. The app comes with a basic database (the date in which it was updated appears on the top-right conrner of the frame in blue). If you want to update the database adding new experiments just connect to the Lab sever (./data) and click on "UPDATE DATABASE" (NB only Tempo log file are considered). You may have to deal with dialog windows if some new experiment has an unexpected format) 
3. Now you can start your search! (look at the help window)
    - when you select a monkey the protocol window is updated to show you the available protocols for it
    - when you select a protocol the monkeys window is updated to show you the monkeys on which that protocol was run 
    - you can select multiple monkeys to see the combined parameters
    - When you push "UPDATE PARAMETERS" (red button) you can see all the available experimental parameters (metadata) on the top right window.
    - On the bottom right window you can see the list of all the corresponding experiments
    - You can now specify in the last column of the top-right window which parameters you want to filter out of the ones proposed in the second column. Then you can push "UPDATE PARAMETERS" to do the filtration and update the window
    - notice that also the list of experiments in the bottom right window has been updated 
    - You can reset this search with the orange button to the right and do another one
    - When you are happy, you can select the experiments you want to use in the bottom-right window/spreadsheet and push the blue button "EXPORT EXP LIST" . This will open a window to export the list of experiments and their metadata. 
5. Export this list as a Matlab or Excel table file. This table can be loaded directly to RunDA to run analysis on these experiments  


or run “RunEF.m” in the command window



---
# For developers
Main File is “EF_GUI.m”

- Update message in the GUI dialog box 
%- info --
STX={ '' ...
    'YOU HAVE CANCELED THE DATABASE UPDATE '};
set(handles.Support,'String',STX)
% ----    
