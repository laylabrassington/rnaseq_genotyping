#!/bin/bash
#SBATCH --mail-user=your_email
#SBATCH --mail-type=ALL
#SBATCH -J processing_rnaseq_genotype_data
#SBATCH -n 1                   
#SBATCH --cpus-per-task=8             
#SBATCH --time=10:00:00               
#SBATCH --mem=64GB
#SBATCH --output=processing_rnaseq_genotype_%j.out


# Define output directory
cd /filepath_with_bam_files/
output="/out_filepath" 
in="/filepath_with_bam_files/" 

echo "loading modules..."
ml StdEnv/2023  gcc/12.3
ml StdEnvACCRE/2023  gcc/12.3
ml bcftools/1.18
gatk=/filepath/mSTARR/gatk-4.1.4.0
plink=/filepath/plink_linux_x86_64_20220402


# Step 0: Make a merged file (index files and merge) 
echo "indexing files..."
for vcf in *.filt.vcf.gz; do
    bcftools index -t $vcf


echo "merging files..."
bcftools merge -O z -o $output/merged.vcf.gz *.filt.vcf.gz


# Step 1: Filter the existing merged VCF to retain only "PASS" variants
echo "Counting initial variants in merged VCF..."
bcftools stats $output/merged.vcf.gz | grep "^SN" | grep "number of records:"

bcftools view -f PASS -O z -o $output/merged_pass.vcf.gz $output/merged.vcf.gz


echo "Counting variants after 'PASS' filter..."
bcftools stats $output/merged_pass.vcf.gz | grep "^SN" | grep "number of records:"


# Index the new filtered VCF file
bcftools index -t $output/merged_pass.vcf.gz

num_samples=$(bcftools query -l $output/merged_pass.vcf.gz | wc -l)


# Step 2: Filter for missingness and MAF < 1%
echo "Filtering for missingness and minor allele frequency..."

ml StdEnv/2020
ml java/11.0.2

$gatk/gatk VariantFiltration \
  -V $output/merged_pass.vcf.gz \
  --filter-expression "AN < 0.5 * $num_samples * 2" \
  --filter-name "Missingness" \
  --filter-expression "AF < 0.01" \
  --filter-name "LowMAF" \
  -O $output/filtered_missing_maf.vcf.gz


ml StdEnv/2023  gcc/12.3
ml StdEnvACCRE/2023  gcc/12.3
ml bcftools/1.18
echo "Retaining only PASS variants after filtering..."
bcftools view -f PASS -O z -o $output/filtered_missing_maf_PASS.vcf.gz $output/filtered_missing_maf.vcf.gz

# Count variants after missingness and MAF filtering
echo "Counting variants after missingness and MAF filtering..."
bcftools stats $output/filtered_missing_maf_PASS.vcf.gz | grep "^SN" | grep "number of records:"

ml StdEnv/2020
ml java/11.0.2

# Step 3: Convert filtered VCF to PLINK format
echo "Converting VCF to PLINK format..."
$plink/plink --noweb --vcf $output/filtered_missing_maf_PASS.vcf.gz \
  --make-bed \
  --out $output/plink_data --double-id 

# Step 4: Apply Hardy-Weinberg equilibrium filtering
echo "Applying Hardy-Weinberg filtering..."
$plink/plink --noweb --bfile $output/plink_data \
  --hwe 1e-6 midp \
  --make-bed \
  --out $output/plink_hwe_filtered

# Count variants after HWE filtering
echo "Counting variants after Hardy-Weinberg filtering..."
$plink/plink --bfile $output/plink_hwe_filtered --missing --freq --out $output/plink_hwe_filtered_summary

echo "done :)"
