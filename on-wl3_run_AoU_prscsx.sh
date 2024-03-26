#!/bin/bash

#I ran the GWAS on AoU workbench,
#gzipped and downloaded the sumstats (each ~13MB)

#AoU training height sample sizes
#afr=46784, amr=34717, eur=105791

#wl3 dir
mydir=/home/isabelle/PRSCSx/

pheno=bmi

pop1=afr
n1=46784
pop2=amr
n2=34717
pop3=eur
n3=105791
phi=1e-2

N_THREADS=10 #only have 4 CPU & 15GB RAM on AoU cloud (better to run on wl3)
export MKL_NUM_THREADS=$N_THREADS
export NUMEXPR_NUM_THREADS=$N_THREADS
export OMP_NUM_THREADS=$N_THREADS

for k in {1..2}
do
/home/wheelerlab3/anaconda2/bin/python /home/wheelerlab3/2023-09-08_PRSCSx/PRScsx/PRScsx.py \
--ref_dir=/home/wheelerlab3/Data/PRS_LD_refs/ \
--bim_prefix=/home/wheelerlab3/2023-09-08_PRSCSx/PRSCSx_testing/METS756_merged_pre-imp_rsid_chr1-22 \
--sst_file=${mydir}gwas/GWAS-${pheno}_AoU_training10fold_group${k}_${pop1}_scaled_${pheno}.sumstats.txt,${mydir}gwas/GWAS-${pheno}_AoU_training10fold_group${k}_${pop2}_scaled_${pheno}.sumstats.t>
--n_gwas=$n1,$n2,$n3 \
--pop=${pop1^^},${pop2^^},${pop3^^} \
--phi=${phi} \
--out_dir=${mydir}prscsx_out_trainAoU-10fold_METS756_bim/ \
--out_name=AoU_scaled_${pheno}_group${k} \
--chrom=4,5,12,13,20,21 \
--seed=777  
done

#to run in the bkgd, enter this on the command line:

# nohup time ./run_AoU_prscsx.sh > prscsx.out.a &


#--chrom=1,8,9,16,17
#--chrom=2,7,10,15,18
#--chrom=3,6,11,14,19,22
#--chrom=4,5,12,13,20,21
