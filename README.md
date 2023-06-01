# sptPALM-Analysis (SPA) :microscope:
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=flat-square)](https://creativecommons.org/licenses/by-nc-sa/4.0/)
[![stars](https://img.shields.io/github/stars/AdamDHines/sptPALM-Analysis.svg?style=flat-square)](https://github.com/AdamDHines/sptPALM-Analysis/stargazers)
[![GitHub Clones](https://img.shields.io/badge/dynamic/json?color=success&label=Clone&query=count&url=https://gist.githubusercontent.com/AdamDHines/bddab1ad93ef30141a8cde52bab35b25/raw/clone.json&logo=github)](https://github.com/MShawon/github-clone-count-badge)
[![HitCount](https://hits.dwyl.com/AdamDHines/sptPALM-Analysis.svg?style=flat-square)](http://hits.dwyl.com/AdamDHines/sptPALM-Analysis)

This repository contains code for the semi-automated analysis of single particle tracking & photoactivatable localization microscopy (sptPALM), developed from the following papers:
* [Tracking Single Molecule Dynamics in the Adult Drosophila Brain](https://www.eneuro.org/content/8/3/ENEURO.0057-21.2021)
* [Synapse-specific trapping of Syntaxin1a into nanoclusters by the general anesthetic isoflurane](https://www.biorxiv.org/content/10.1101/2023.02.27.530184v1)

**_If you found this code useful or helpful for your research, please consider giving the repository a star :star:._**

## License and Citation

This code is licensed under the [MIT License](https://choosealicense.com/licenses/mit/)

If you use this code (verbatim or modified) in your publication, please cite the following publication:
* [Hines, AD. & van Swinderen, B. 2021 eNeuro 8(3)](https://www.eneuro.org/content/8/3/ENEURO.0057-21.2021)

## Setup and installation
sptPALM-Analysis was written and developed in MATLAB 2018b, so it will be best to use this specific version but it has been tested on up to MATLAB 2020 versions with no issues.

> **Note**
>Since the code is no longer being actively worked on or developed, we make no guarantee it will be functional in newer versions of MATLAB.

To install, simply clone this repository `>git clone git@github.com:AdamDHines/sptPALM-Analysis.git` or by downloading the ZIP file. The repository comes with [FIJI](https://imagej.net/software/fiji/downloads), so no need to install this separately. A pre-existing FIJI install will not affect anything.

Open MATLAB and set the folder to the sptPALM-Analysis folder you just cloned. Simply type `start` into the command window and press `Enter` to begin the program.

### Run performance
This code uses [TrackMate](https://imagej.net/plugins/trackmate/) to perform sptPALM, which parallelizes spot detection based on the number of CPU cores. This can be computationally quite slow if using large image sequenes (>10,000 frames).

## How to use
A (sort of) detailed description is provided in the pdf document _sptPALM Analysis Guide_ (currently incomplete) of how to use the code is available [here](https://github.com/AdamDHines/sptPALM-Analysis/blob/master/Documentation/sptPALM%20Analysis%20Guide.pdf) or in the `/Documentation` folder of the cloned repository.

Not specified in the analysis guide pdf are a few extra settings, which will be detailed here:

### _Requirements_
Please check pages 15 - 17 of the [analysis guide](https://github.com/AdamDHines/sptPALM-Analysis/blob/master/Documentation/sptPALM%20Analysis%20Guide.pdf) which details some critical information on data structure and file type. Currently, you need to have the raw data file in the same folder as the converted .tif file otherwise errors will been thrown. 

### _Set the threshold values_
Once you've determined the  threshold value for the spot detection (page 16 of [analysis guide](https://github.com/AdamDHines/sptPALM-Analysis/blob/master/Documentation/sptPALM%20Analysis%20Guide.pdf)), press `Set` in the `Set Threshold Values` pane. Type in the threshold values calculated, seperating them with _only_ a space. Threshold values are entered and used in the order the files are organised in the analysis folder.

### _Apply drift correction?_
Drift correction capability was added, details of which are available in [Hines, AD. et al. 2023 bioRxiv](https://www.biorxiv.org/content/10.1101/2023.02.27.530184v1). If you wish to use this feature, currently it only takes the x,y drift values generated from the model based drift correction by the Zeiss ZEN PALM plugin. 

To use, copy and paste the x,y drift values from ZEN into an excel spreadsheet and save with the same name as your data file making sure it is a .csv file. Add the .csv files into a new folder called `DriftTables` in the same directory as your data files 

> **Note**
>the name DriftTables is critical, it won't work otherwise.

When running the program, select the `Apply drift correction?` button in the proccessing paramters pane.

### _Allow <1000 trajectories?_
Select this if you want sptPALM-Analysis to allow MSD and diffusion coefficient calculations on files that had less than 1000 trajectories detected. (_Recommended_)

### Setting sptPALM Parameters and Processing Parameters
This is the part where an individual usecase will need to determine what parameters are used. The default settings were optimised for tracking Syntaxin1a-mEos2 molecules on a 2012 Zeiss ELYRA PS.1 with an EMCCD camera. We recommend keeping `Track Minimum`, `Track Maximum`, and `MSD Fitting` values the same.

Use the `Spot radius` value (half the spot diameter value used in the main TrackMate GUI) that you used to determine the threshold values. 

The `Maximum Linking Distance` is the max distance two detected spots can be linked together from one frame to the next. This depends on the biology of your desired molecule. Generally, for membrane anchored proteins 0.3um and cytosolic protein 0.8um are good starting points.

`Time Delta` is the exposure rate of the camera during acquisition, adjust accordingly.

`Mobile:Immobile` cutoff is a little trickier to calculate and is based on the pixel dimensions of the camera used for acquisition. Please see the following [paper](https://www.sciencedirect.com/science/article/pii/S0896627315000380?via%3Dihub) to determine how to calculate this value.

## Issues and troubleshooting
If you run into a bug or issue, please [report it](https://github.com/AdamDHines/sptPALM-Analysis/issues). 
> **Note**
>I cannot guarantee a solution to any coding problems, but will be able to easily resolve any usecase issues.
