#run this script to concatenate all the chromosome GWAS results

#install needed R packages
lapply(c('dplyr','R.utils'),
       function(pkg) { if(! pkg %in% installed.packages()) {  install.packages(pkg) } } )
#library(qqman)
library(data.table)
library(dplyr)
"%&%" = function(a,b) paste(a,b,sep="")

#read in gwas results per pop and plot
for(n in (1:10)){
for(pop in c("afr","amr","eur")){
    res = fread("gwas/group"%&%n%&%"/GWAS-bmi_AoU_training10fold_group"%&%n%&%"_" %&% pop %&% "_chr1.scaled_bmi.glm.linear")
    for(i in 2:22){
    chrres = fread("gwas/group"%&%n%&%"/GWAS-bmi_AoU_training10fold_group"%&%n%&%"_" %&% pop %&% "_chr" %&% i %&% ".scaled_bmi.glm.linear")
    res = rbind(res,chrres)
    }
    #subset to ADD rows and plot
    res = dplyr::filter(res,TEST=="ADD")
    #remove NA's before plotting
    res = dplyr::filter(res, !is.na(P)) |> mutate(P=as.numeric(P))
    #print(manhattan(res,chr="#CHROM",bp="POS",snp="ID",main=pop,col=c("orange","black")))
    #print(qq(res$P,main=pop))
    #write sumstats to file for prs-csx
    print(dim(res))
    #select needed data for prs-csx
    sumstats = dplyr::select(res, ID, ALT, REF, BETA, SE)
    colnames(sumstats) = c("SNP","A1","A2","BETA","SE")
    print(head(sumstats))
    fwrite(sumstats, "gwas/GWAS-bmi_AoU_training10fold_group"%&%n%&%"_" %&% pop %&% "_scaled_bmi.sumstats.txt",row.names = FALSE,sep='\t')
}
    }
