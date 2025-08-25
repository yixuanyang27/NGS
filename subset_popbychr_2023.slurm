#!/bin/bash
#SBATCH --job-name=subset_popbychr_2023
#SBATCH --output=subset_popbychr_2023_%j.out
#SBATCH --error=subset_popbychr_2023_%j.err
#SBATCH --time=18:00:00
#SBATCH --mem=96G
#SBATCH --cpus-per-task=4
#SBATCH --partition=scc-cpu

# Load environment
module load miniforge3
source activate bcfenv

# Define variables
INPUT_DIR="/scratch1/projects/scc_zgzu_ceres/data/AllSites_bypop"
OUTPUT_DIR="/scratch1/projects/scc_zgzu_ceres/data/AllSites_popbychr"
VCF_PREFIX="AllSites_Ger2023_hap"
CHROMS=(chr1 chr2 chr3 chr4 chr5 chr6 chr7 chr8 chr9 chr10 mitochondrial_genome)
POPS=(A C D E dlf kws ses strube)

# Loop over populations
for POP in "${POPS[@]}"; do
    INFILE="${INPUT_DIR}/${VCF_PREFIX}_${POP}.vcf.gz"
    OUTPOP_DIR="${OUTPUT_DIR}/2023_${POP}"

    mkdir -p "${OUTPOP_DIR}"

    # Loop over chromosomes
    for CHR in "${CHROMS[@]}"; do
        OUTFILE="${OUTPOP_DIR}/${VCF_PREFIX}_${POP}_${CHR}.vcf.gz"
        echo "Subsetting ${INFILE} for ${CHR} -> ${OUTFILE}"
        bcftools view -r ${CHR} -Oz -o "${OUTFILE}" "${INFILE}"
        bcftools index "${OUTFILE}"
    done
done
