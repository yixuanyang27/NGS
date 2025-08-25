#!/bin/bash
#SBATCH --job-name=vcf_extract_2022
#SBATCH --output=vcf_extract_2022_%j.out
#SBATCH --error=vcf_extract_2022_%j.err
#SBATCH --time=18:00:00
#SBATCH --mem=96G
#SBATCH --cpus-per-task=4
#SBATCH --partition=scc-cpu

# Load bcftools environment
module load miniforge3
source activate bcfenv

# Input VCF file
INPUT_VCF=/scratch1/projects/scc_zgzu_ceres/data/AllSites_Ger2022_hap.vcf.gz

# Sample list directory
SAMPLE_DIR=/scratch1/projects/scc_zgzu_ceres/data/sample_bypop

# Output directory 
OUT_DIR=/scratch1/projects/scc_zgzu_ceres/data/AllSites_bypop

# Loop through each sample list and extract samples for 2022
for sample_file in "$SAMPLE_DIR"/meta_22_*.txt; do
    # Extract pop ID from file name (e.g. "A" from meta_22_A.txt)
    pop_id=$(basename "$sample_file" .txt | cut -d'_' -f3)
    
    echo "Extracting population: $pop_id"
    
    # Output file
    OUT_VCF="$OUT_DIR/AllSites_Ger2022_hap_${pop_id}.vcf.gz"
    
    # Subset VCF
    bcftools view -S "$sample_file" -Oz -o "$OUT_VCF" "$INPUT_VCF"
    
    # Index the output VCF
    bcftools index "$OUT_VCF"
done

echo "✅ All 2022 population-specific VCFs created in: $OUT_DIR"
