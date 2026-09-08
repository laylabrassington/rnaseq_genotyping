#create PCA and relatedness matrix (relationship inference)
#need to be in directory w/ "plink_hwe_filtered" from script "processing_rnaseq_genotypes.sh"
#will have to adjust plink filters to match your data, values here are just examples 

#filtering
/filepath/plink_linux_x86_64_20220402/plink --noweb --bfile plink_hwe_filtered --geno 0.3 --maf 0.005 --make-bed --out plink_final_filtered

#relatedness
/filepath/king -b plink_final_filtered.bed --related --degree 2 --prefix king_related

#kinship 
/filepath/king -b plink_final_filtered.bed --kinship --prefix king_kinship

#filtering for PCA
/filepath/plink_linux_x86_64_20220402/plink --noweb --bfile plink_final_filtered --geno 0.1 --make-bed --out pca_filt

#PCA
/filepath/plink_linux_x86_64_20220402/plink --noweb --bfile pca_filt --pca  --mind 0.5 --out plink_pca

