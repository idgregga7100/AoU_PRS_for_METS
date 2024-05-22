library(data.table)
library(tidyverse)  # Data wrangling packages.
#paste function to concatenate filenames/paths
"%&%" = function(a,b) paste(a,b,sep="")

#PHENO WRANGLING SECTION

#retrieve phenotypes from bucket and read in
name_of_file_in_bucket <- 'height_weight_demog_2023-09-27.txt'
# Get the bucket name
#my_bucket <- Sys.getenv('WORKSPACE_BUCKET')
my_bucket<-c('gs://fc-secure-09b7d164-67b2-4c94-8381-4b8202619ea8')
# Copy the file from current workspace to the bucket
system(paste0("gsutil cp ", my_bucket, "/data/", name_of_file_in_bucket, " ."), intern=T)

# Load the file into a dataframe
pheno  <- fread(name_of_file_in_bucket)
dim(pheno)
head(pheno)

#retrieve ancestry PCs from bucket and read in
#Note: this is from another workspace 
#my "Duplicate of How to Work with All of Us Genomic Data (Hail - Plink)(v7)"
#get AoU PCs
system("gsutil -u $GOOGLE_PROJECT cp gs://fc-aou-datasets-controlled/v7/wgs/short_read/snpindel/aux/ancestry/ancestry_preds.tsv .")
ancestry = fread("ancestry_preds.tsv")
head(ancestry)

#make dataframe of just IDs and PCs
#first remove square brackets in pca_features w/substr 
ancestry2 <- mutate(ancestry, pca_features=substr(pca_features,2,nchar(pca_features)-1))
head(ancestry2)
#then split on commas 
pcs <-str_split_fixed(ancestry2$pca_features, ',', 16)
head(pcs)

#convert characters (chr) to numeric (dbl) type and add id's
pcs <- matrix(as.numeric(pcs),ncol=16)
rownames(pcs) <- ancestry$research_id
head(pcs)
#make a data.frame for later joining, add predicted genetic ancestry
pc_df <- as.data.frame(pcs) |> mutate(research_id=rownames(pcs),ancestry_pred_other=ancestry$ancestry_pred_other)
head(pc_df)

#SCORES SECTION

#this whole thing per group k oof
for(k in 1:9){
#Read and combine PRS's (add up chr scores per population)
scoredir="scores_10fold/"
n=20809 #number of people in .sscore files
#make matrix to add each pop's PRS to
all_prs = matrix(nrow=n,ncol=3) #people x #pops
pops = c("AFR","AMR","EUR")
for(i in 1:length(pops)){
  pop = pops[i]
  #make matrix to add each chr's score to
  prs = matrix(nrow=n,ncol=22) # #people x #chromosomes
  #load matrix
  for(j in 1:22){
    #read in scores calculated in held-out AoU (these were trained in AoU with SNPs in METS756 .bim file)
    scores = fread(scoredir %&% "AoU_scaled_bmi_" %&% pop %&% "_pst_eff_a1_b0.5_phi1e-04_chr" %&% j %&% "_group"%&%k%&%"_heldout.sscore")
    prs[,j] = scores$SCORE1_AVG
  }
  sum_prs = scale(rowSums(prs)) #take the sum of each row and scale (mean=0,var=1) to generate final PRS
  #add to pop matrix
  all_prs[,i] = sum_prs
  #add sample IID's as rownames
  rownames(all_prs) = scores$`#IID`
  #add pops as colnames
  colnames(all_prs) = pops
}

#join height PRS's with ancestry PCs
prs_df = data.frame(all_prs) |> mutate(research_id=rownames(all_prs))
head(prs_df)

prs_pcs = inner_join(prs_df,pc_df,by='research_id')
head(prs_pcs)
dim(prs_pcs)

#join PRS and PCs w/phenotypes
#need person_id in pheno to be characters
pheno = mutate(pheno,research_id=as.character(person_id))
all_data = inner_join(prs_pcs,pheno,by='research_id')
head(all_data) 
colnames(all_data)
#write all_data to text file.
fwrite(all_data,"AoU_scaled_bmi_PRSCSx_phi1e-04_in_AoU_group"%&%k%&%"_held-out_w_pheno.txt",quote=F,row.names=F,sep='\t')
#cp to bucket
system("gsutil -m cp AoU_scaled_bmi_PRSCSx_phi1e-04_in_AoU_group"%&%k%&%"_held-out_w_pheno.txt ${WORKSPACE_BUCKET}/data/")
}

#group 10 separately because group 10 n=20820
for(k in 10:10){
#Read and combine PRS's (add up chr scores per population)
scoredir="scores_10fold/"
n=20820 #number of people in .sscore files
#make matrix to add each pop's PRS to
all_prs = matrix(nrow=n,ncol=3) #people x #pops
pops = c("AFR","AMR","EUR")
for(i in 1:length(pops)){
  pop = pops[i]
  #make matrix to add each chr's score to
  prs = matrix(nrow=n,ncol=22) # #people x #chromosomes
  #load matrix
  for(j in 1:22){
    #read in scores calculated in held-out AoU (these were trained in AoU with SNPs in METS756 .bim file)
    scores = fread(scoredir %&% "AoU_scaled_bmi_" %&% pop %&% "_pst_eff_a1_b0.5_phi1e-04_chr" %&% j %&% "_group"%&%k%&%"_heldout.sscore")
    prs[,j] = scores$SCORE1_AVG
  }
  sum_prs = scale(rowSums(prs)) #take the sum of each row and scale (mean=0,var=1) to generate final PRS
  #add to pop matrix
  all_prs[,i] = sum_prs
  #add sample IID's as rownames
  rownames(all_prs) = scores$`#IID`
  #add pops as colnames
  colnames(all_prs) = pops
}

#join height PRS's with ancestry PCs
prs_df = data.frame(all_prs) |> mutate(research_id=rownames(all_prs))
head(prs_df)

prs_pcs = inner_join(prs_df,pc_df,by='research_id')
head(prs_pcs)
dim(prs_pcs)

#join PRS and PCs w/phenotypes
#need person_id in pheno to be characters
pheno = mutate(pheno,research_id=as.character(person_id))
all_data = inner_join(prs_pcs,pheno,by='research_id')
head(all_data) 
colnames(all_data)
#write all_data to text file.
fwrite(all_data,"AoU_scaled_bmi_PRSCSx_phi1e-04_in_AoU_group"%&%k%&%"_held-out_w_pheno.txt",quote=F,row.names=F,sep='\t')
#cp to bucket
system("gsutil -m cp AoU_scaled_bmi_PRSCSx_phi1e-04_in_AoU_group"%&%k%&%"_held-out_w_pheno.txt ${WORKSPACE_BUCKET}/data/")
}
