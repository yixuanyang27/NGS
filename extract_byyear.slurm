#!/bin/bash
#SBATCH --job-name=index_vcf
#SBATCH --output=index_vcf_%j.out
#SBATCH --error=index_vcf_%j.err
#SBATCH --time=20:00:00
#SBATCH --mem=96G
#SBATCH --cpus-per-task=4
#SBATCH --partition=scc-cpu

# Load environment
module load miniforge3
source activate bcfenv


VCF="AllSites.filtered.recode.haploid.vcf.gz"

# Define sample sets
declare -A samplesets=(
    [2022]="AllSites_2022.txt"
    [2023]="AllSites_2023.txt"
    [2024]="AllSites_2024.txt"
)

# Loop through years
for year in "${!samplesets[@]}"; do
    SAMPLE_FILE="${samplesets[$year]}"
    OUTFILE="AllSites_Ger${year}_hap.vcf.gz"

    echo "Extracting samples for $year from $SAMPLE_FILE..."
    
    bcftools view \
        --samples-file "$SAMPLE_FILE" \
        --output-type z \
        --output "$OUTFILE" \
        "$VCF"

    if [[ $? -ne 0 ]]; then
        echo "Error extracting samples for $year"
        exit 1
    fi

    echo "Indexing $OUTFILE..."
    bcftools index "$OUTFILE"
done

echo "✅ All done!"
