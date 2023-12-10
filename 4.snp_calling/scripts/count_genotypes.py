import sys
import subprocess
import pandas as pd

def get_genotype_counts(vcf_path):
    # Construct the bcftools command
    command = f"bcftools query -f '[%GT]\\n' {vcf_path} | sort | uniq -c"
    # Run the command and capture the output
    result = subprocess.run(command, shell=True, stdout=subprocess.PIPE, text=True)
    # Parse the output
    counts = {}
    for line in result.stdout.split('\n'):
        if line.strip():
            count, genotype = line.split(maxsplit=1)
            counts[genotype] = int(count)
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
    "Raw basepair-resolution VCF": f"{BASE_PATH}/{SAMPLE_NAME}.Genot.full.bcf",
    "Main scaffolds & no Sex chromosomes basepair-resolution VCF": f"{BASE_PATH}/temp_{SAMPLE_NAME}.Genot.full.mainNoSex.vcf",
    "Filtered, masked, main scaffolds & no Sex chromosomes basepair-resolution VCF": f"{BASE_PATH}/filtered/{SAMPLE_NAME}.Genot.full.mainNoSex.mask.filt.vcf.bgz",
    "Filtered, masked, main scaffolds & no Sex chromosomes VCF": f"{BASE_PATH}/filtered/{SAMPLE_NAME}.Genot.PASS.bcf"
}

# Collect genotype counts for each VCF file
data = {stage: get_genotype_counts(path) for stage, path in vcf_paths.items()}

# Convert the data to a pandas DataFrame
df = pd.DataFrame(data).fillna(0).astype(int)
df.index.name = "Genotype"
df = df.reset_index()

# Optionally, save the DataFrame to a CSV file
output_csv = f"{BASE_PATH}/filtered/genotype_counts_table.csv"
df.to_csv(output_csv, index=False)

# Display the DataFrame
print(df)
