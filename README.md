# Psychophysics Project

This an implementation of a method presented in [Afraz, A., Pashkam, M. and Cavanagh, P., 2010. Spatial Heterogeneity in the Perception of Face and Form Attributes. Current Biology, 20(23), pp.2112-2116.](https://doi.org/10.1016/j.cub.2010.11.017)
to show that perception of gender of face depends on the location in visual field. This project was implemeted using psychtoolbox in Matlab.
This was one of my course-project for "Introduction to Cognitive Neuroscience".

# Using Introduction

To perform the experiment on a subject, ask him/her to sit infront of the monitor, then simply run Experiment.m to setup and run psychtoolbox environment and save the gained data in "\Results".
To fit and compare Psychometric Function for two angular locations 90 and 180deg, simply run Psychometric_Function.m .

# Experimental Design

First, train the subjects to identify a face (one of 9 morphings generated using facegen) that appears in the middle of screen using left and right arrow keys. As soon as they reach accuracy of 85% the main experiment will begin,
since then, in each trial a red point will appear in the middle of screen for 0.5 seconds followed by a face in one of two angular locations for 0.05 they they must identify the gender as same as they did during the training phase.
A total of 180 trials, 10 times for each face in each location will perform.

# Example

A sample dataset consist of the data of 12 subjects is available in this repository as an example.

![See Psychometric_Function.png](/Psychometric_Function.png)

# Acknowledge

With many thanks to Mehdi one of my classmates who have generated faces and made them available for everyone.
