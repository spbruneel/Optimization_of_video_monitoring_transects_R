# Optimization_of_video_monitoring_transects_R

Sampling errors and variability in video transects for assessment of reef fish assemblage structure and diversity. The code used in this repository was used for the evaluation and optimization of video monitoring transects for reef fish community assessment.

## Description of the data:

Two datasets are provided: The real dataset and a fake dataset with less species to reduce computation time. For the fake data, random observations were generated for only 5 of the observed species. Randomization with a range of [0,100] and with a 50/50 percent change on absence/presence was used. Each biological data frame contains the observations as rows and factors as columns. Per data frame the Island, Location, Transect, Person, Repeat number and Video analyst are given. The observed species (count per observation) and the total amount of species observed per observation are given. A distinction is made between the different transect lengths of 10, 20, 30, 40 and 50 meter. Empty values in the species columns indicate absences (=0). 

- N10.xlsx
- N20.xlsx
- N30.xlsx
- N40.xlsx
- N50.xlsx


In the data frame “autocorrelation_check.xlsx” the order of the repeats was given in order to assess the significance of temporal autocorrelation between the observations.

The file “specieslist.xlsx” gives the observed species of the real dataset. The file “specieslist_fake.xlsx” gives the subset of observed species of the fake dataset. 

## Description of the code:

- Optimization_of_video_monitoring_transects.Rmd: Rmarkdown script used to do most of the analyses. More information is given as comments in the code.
- glmmtmb_models.R: R script to develop univariate zero-inflated generalized linear mixed models. More information is given as comments in the code. The developed models are stored in the folder Rdata.
