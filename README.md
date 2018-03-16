# Effect-of-ibuprofen-on-BrainAGE

## Effect of Ibuprofen on BrainAGE: a randomized, placebo-controlled, dose-response exploratory study

Written by Trang Le

Methods are described in the following study.

Trang T. Le, Rayus Kuplicki, Hung-wen Yeh, Robin L. Aupperle, Sahib S. Khalsa, W. Kyle Simmons, Martin P. Paulus.
"Effect of Ibuprofen on BrainAGE: a randomized, placebo-controlled, dose-response exploratory study"


# Abstract
## Background
The age of a person’s brain can be estimated from structural brain images using an aggregate measure of variation in morphology across the whole brain. The “Brain Age Gap Estimation” (i.e., BrainAGE) score is computed as the difference between kernel-estimated brain age and chronological age. In this exploratory study, we investigated the application of the BrainAGE measure to identify potential novel effects of pharmacological agents on brain morphology. 
## Methods
Twenty healthy participants (23–47 years old) completed three structural MRI scans 45 minutes after administration of placebo, 200, or 600mg of ibuprofen in a double-blind and cross-over study. An externally derived BrainAGE model from a sample of 480 healthy participants was used to examine the acute effect of ibuprofen on temporary neuroanatomical changes in healthy individuals.
## Results
The BrainAGE model produced age prediction for each participant with a mean absolute error of 6.7 years between the estimated and chronological age. The intraclass correlation coefficient for BrainAGE was 0.96.  Relative to placebo, 200 and 600 mg of ibuprofen significantly decreased BrainAGE by 1.15 and 1.18 years, respectively (p<0.05). The trained BrainAGE model identified the medial prefrontal cortex to be the strongest age predictor.
## Conclusion
BrainAGE is a potentially useful construct to examine neurological effects of therapeutic drugs. Ibuprofen temporarily reduces BrainAGE by approximately one year, which is likely due to its acute anti-inflammatory effects. 

## Trial registration
The ibuprofen trial is registered at the US National Institutes of Health (ClinicalTrials.gov) #NCT02507219.
## URL
https://clinicaltrials.gov/ct2/show/NCT02507219?term=Ibuprofen+fmri&rank=1
## Funding
Funding for this study was provided by the William K. Warren Foundation and the National Institute of Mental Health 

## Description
The repo currently consists of 3 files:
*ibuBrainAGE.R*: This R script computes BrainAGE on the ibuprofen dataset (Dataset 2) and tests for the effect of different ibuprofen dosage (placebo, 200mg, 600mg) on BrainAGE
*ibuDataNoImaging.RData*: demographics data of the ibuprofen dataset, imaging data not included
*ibuResults.RData*: predicted BrainAGE of participants in the ibuprofen dataset
