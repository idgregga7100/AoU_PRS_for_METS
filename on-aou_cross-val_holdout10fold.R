library(tidyverse)  # Data wrangling packages.
library(data.table)
"%&%" = function(a,b) paste(a,b,sep="")

#pheno file
#system('gsutil cp ${WORKSPACE_BUCKET}/data/AoU_height_bmi_demog_pca_n234585.txt .')
data<-fread('AoU_height_bmi_demog_pca_n234585.txt')
head(data)
str(data)

#go through ids, use sample without replacement fn to get 10 groups, every indiv in one of the groups, no overlap
#per each pop
set.seed(7)

afr = filter(data,ancestry_pred_other=="afr")
dim(afr)
n<-round(nrow(afr)/10)
print(n)
for(i in 1:9){
    print(i)
    holdout<-sample(x=afr$person_id,size=n,replace=F)
    fwrite(data.frame(holdout),'aou_holdout10fold_afr_id_group'%&%i%&%'.txt',col.names=F,quote=F,sep='\t')
    afr<-filter(afr,!person_id%in%holdout)
}
dim(afr)
fwrite(data.frame(afr$person_id),'aou_holdout10fold_afr_id_group10.txt',col.names=F,quote=F,sep='\t')

#copy to bucket
#system("gsutil -m cp aou_holdout10k_*_id.txt ${WORKSPACE_BUCKET}/data/")

set.seed(7)
amr = filter(data,ancestry_pred_other=="amr")
dim(amr)
n<-round(nrow(amr)/10)
print(n)
for(i in 1:9){
    print(i)
    holdout<-sample(x=amr$person_id,size=n,replace=F)
    fwrite(data.frame(holdout),'aou_holdout10fold_amr_id_group'%&%i%&%'.txt',col.names=F,quote=F,sep='\t')
    amr<-filter(amr,!person_id%in%holdout)
}
dim(amr)
fwrite(data.frame(amr$person_id),'aou_holdout10fold_amr_id_group10.txt',col.names=F,quote=F,sep='\t')

eur = filter(data,ancestry_pred_other=="eur")
dim(eur)
n<-round(nrow(eur)/10)
print(n)
for(i in 1:9){
    print(i)
    holdout<-sample(x=eur$person_id,size=n,replace=F)
    fwrite(data.frame(holdout),'aou_holdout10fold_eur_id_group'%&%i%&%'.txt',col.names=F,quote=F,sep='\t')
    eur<-filter(eur,!person_id%in%holdout)
}
dim(eur)
fwrite(data.frame(eur$person_id),'aou_holdout10fold_eur_id_group10.txt',col.names=F,quote=F,sep='\t')

#copy to bucket
system("gsutil -m cp aou_holdout10fold_*_id_group*.txt ${WORKSPACE_BUCKET}/data/")
