import sys
import subprocess
import csv

def update_genotype_counts(vcf_path, accumulated_counts, stage):
    command = f"bcftools query -f '[%GT]\\n' {vcf_path}"
    with subprocess.Popen(command, shell=True, stdout=subprocess.PIPE, text=True) as proc:
        for line in proc.stdout:
            genotype = line.strip()
            if genotype:
                if genotype not in accumulated_counts:
                    accumulated_counts[genotype] = {s: 0 for s in vcf_paths}
                accumulated_counts[genotype][stage] += 1

if len(sys.argv) != 5:
    print("Usage: python count_genotypes.py <OUT_DIR> <SPECIES_NAME> <ASSEMBLY_ID> <SAMPLE_NAME>")
    sys.exit(1)

OUT_DIR, SPECIES_NAME, ASSEMBLY_ID, SAMPLE_NAME = sys.argv[1:5]
BASE_PATH = f"{OUT_DIR}/jATG/{SPECIES_NAME}/{ASSEMBLY_ID}/{SAMPLE_NAME}/4.calling/2_VCFs"

vcf_paths = {
    "Raw basepair": f"{BASE_PATH}/{SAMPLE_NAME}.Genot.full.bcf",
    "Main autosome basepair": f"{BASE_PATH}/temp_{SAMPLE_NAME}.Genot.full.mainNoSex.bcf",
    "Filtered basepair": f"{BASE_PATH}/filtered/{SAMPLE_NAME}.Genot.full.mainNoSex.mask.filt.vcf.bgz",
    "Filtered": f"{BASE_PATH}/filtered/{SAMPLE_NAME}.Genot.PASS.bcf"
}

accumulated_counts = {}
for stage, path in vcf_paths.items():
    update_genotype_counts(path, accumulated_counts, stage)

output_csv = f"{BASE_PATH}/filtered/genotype_counts_table.csv"
with open(output_csv, 'w', newline='') as csvfile:
    csvwriter = csv.writer(csvfile)
    header = ['Genotype'] + list(vcf_paths.keys())
    csvwriter.writerow(header)

    for genotype, counts in accumulated_counts.items():
        row = [genotype] + [counts[stage] for stage in vcf_paths]
        csvwriter.writerow(row)
