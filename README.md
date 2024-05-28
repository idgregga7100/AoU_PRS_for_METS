# AoU_PRS_for_METS

### start on AoU
* 10-fold holdout
* run GWAS on all training groups
* concat sumstats
* DOWNLOAD SUMSTATS AND MOVE TO WL3

### PRS-CSx on WL3 for cross-val pop weights
* run PRSCSx on 90% sumstats, 10 groups
* COPY PRSCSX OUT TO AOU AND MOVE

### validate on AoU for pop weights cross val
* use prscsx out to calc prs in heldodut aou, 10 groups (validate)
* process scores output
* validation command line script for modeling pop-level betas
* DOWNLOAD VAL OUT AND MOVE TO WL3

### PRS-CSx on WL3 for snp weights
* run PRS-CSx on all sumstats, no cross val groups
* no need to bring back to aou to validate snp-level betas

### test in METS on WL3
* testing process: 24-29 from dr w's steps, may rewrite/consolidate some?
* calc PRS in METS, USE snp weight PRS-CSx out (no held out/no cross val groups) 
* post imputation or merged pre and post imputation? which to prioritize?
* afterward use cross-val pop weights to adjust scores
