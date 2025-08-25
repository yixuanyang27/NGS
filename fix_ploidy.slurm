#!/bin/bash
#SBATCH --job-name=fix_ploidy
#SBATCH --output=fix_ploidy_%j.out
#SBATCH --error=fix_ploidy_%j.err
#SBATCH --time=18:00:00
#SBATCH --mem=96G
#SBATCH --cpus-per-task=4
#SBATCH --partition=scc-cpu


# Load environment
module load miniforge3
source activate bcfenv

#fix ploidy
bcftools +fixploidy VarSites.snps.filtered.recode.vcf.gz -- -p haploid.ploidy | bgzip -c > VarSites.snps.filtered.recode.haploid.vcf.gz
#index
bcftools index VarSites.snps.filtered.recode.haploid.vcf.gz
