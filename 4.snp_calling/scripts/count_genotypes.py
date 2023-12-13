import sys
import subprocess
import csv

def get_genotype_counts(vcf_path):
    # Construct the bcftools command
    command = f"bcftools query -f '[%GT]\\n' {vcf_path}"
    # Run the command and capture the output
    result = subprocess.run(command, shell=True, stdout=subprocess.PIPE, text=True)
    # Parse the output
    counts = {}
    for line in result.stdout.split('\n'):
        genotype = line.strip()
        if genotype:
            counts[genotype] = counts.get(genotype, 0) + 1
    return counts

if len(sys.argv) != 5:
    print("Usage: python count_genotypes.py <OUT_DIR> <SPECIES_NAME> <ASSEMBLY_ID> <SAMPLE_NAME>")
    sys.exit(1)

# Capture command-line arguments
OUT_DIR = sys.argv[1]
SPECIES_NAME = sys.argv[2]
ASSEMBLY_ID = sys.argv[3]
SAMPLE_NAME = sys.argv[4]

BASE_PATH = f"{OUT_DIR}/jATG/{SPECIES_NAME}/{ASSEMBLY_ID}/{SAMPLE_NAME}/4.calling/2_VCFs"

# Define the paths to your VCF files
vcf_paths = {
    "Raw basepair": f"{BASE_PATH}/{SAMPLE_NAME}.Genot.full.bcf",
    "Main autosome basepair": f"{BASE_PATH}/temp_{SAMPLE_NAME}.Genot.full.mainNoSex.bcf",
    "Filtered basepair": f"{BASE_PATH}/filtered/{SAMPLE_NAME}.Genot.full.mainNoSex.mask.filt.vcf.bgz",
    "Filtered": f"{BASE_PATH}/filtered/{SAMPLE_NAME}.Genot.PASS.bcf"
}

# Collect genotype counts for each VCF file
data = {stage: get_genotype_counts(path) for stage, path in vcf_paths.items()}

# Write the results to a CSV file
output_csv = f"{BASE_PATH}/filtered/genotype_counts_table.csv"
with open(output_csv, 'w', newline='') as csvfile:
    csvwriter = csv.writer(csvfile)
    csvwriter.writerow(['Genotype'] + list(data.keys()))  # Header
    genotypes = set(gt for counts in data.values() for gt in counts)
    for gt in genotypes:
        row = [gt] + [data[stage].get(gt, 0) for stage in data]
        csvwriter.writerow(row)
