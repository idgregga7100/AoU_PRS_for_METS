#!/bin/bash

#use PRS-CSx AoU training output to calc scores in METS
#scores used here are the prscsx output already generated after the training step--already generated on wl3
#PRE-validation scores

for pop in AFR AMR EUR
do
  for i in {1..22}
  do
  plink2 --pfile /home/wheelerlab3/2023-09-08_PRSCSx/PRSCSx_testing/mets4prscsx_plink/METS735_rsid_chr${i} \
  --score /home/isabelle/PRSCSx/prscsx_out_allAoU_METS756_bim/AoU_scaled_bmi_${pop}_pst_eff_a1_b0.5_phi1e+00_chr${i}.txt 2 4 6 variance-standardize list-variants \
  --out scores_new/METS735_post-imp_AoU_scaled_bmi_${pop}_pst_eff_a1_b0.5_phi1e+00_chr${i}
  done
done

#later come back and add looping through phis and phenos
#damn that was fast, it was only like five min?
