# rnaseq_genotyping
code and instructions for calling genotype info and making a kinship matrix from rnaseq data

tips:

*you should also check that you have all the modules you need before starting (might need to make a conda env)

*also sometimes all the files don't zip properly in step 1 so just make sure they're all there before you continue 

*if using these scripts please make sure you update all the filepaths (also check filepaths for the shared resources e.g. gatk)

# step 1 : variant calling of individual files 
script : tc_genotyping_nohas (nohas is referring to #SBATCH --constraint=haswell bc for a while thats the only way it would run)

what you need: 
- a directory with all of your .bam files
- an out directory for the .filt.vcf.gz files
- an ID file that has the prefixes for the .bam files
- (optional) a secondary ID file to rename files to a shorter ID
- hg38.fa
- 1000G_phase1.snps.high_confidence.hg38.vcf.gz


# step 2 : merging and filtering the files 
script: processing_rnaseq_genotype

what you need:
- the directory with the .filt.vcf.gz files
- a seperate directory for the outfiles 


# step 3 : running PCA and creating kinship matrix 
script: kinship_pca

what you need:
- plink_hwe_filtered .bed file plus id file that goes with
- plink and king programs (should be in lab shared)

other info:
- filtering parameters I picked were really based on the data/what you want to use it for you may have to mess around with it
- there's also "kinship" and "relatedness" from the king program 
  - kinship will give negative estimates of relatedness
  - relatedness caps its lower bound at 0.0884 and just assigns anything below that at 0
- links
  - king (https://www.kingrelatedness.com/manual.shtml)
  - plink (https://www.cog-genomics.org/plink/) (https://zzz.bwh.harvard.edu/plink/tutorial.shtml)
- make sure you have clear naming set up when you run this!!!
  - otherwise it will default pick the file prefix based on the input file and overwrite any file that has that name already


# step 4 : cleaning up the data for use 
script: OA_TC_RNAseq_geno.Rmd

what you need: 
- metadata for your files (as well as naming information)
- .kin0 output from king
- .eigenvec output from plink

* note: my code is build for individuals who have 2 samples in the data so you may need to adjust based on your data














