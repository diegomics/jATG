import sys
import gzip
from Bio import SeqIO

if len(sys.argv) != 4:
    print("Usage: python exclude_scaf.py <asm.fa*(gz)> <exclude_list.txt> <output.fa*(gz)>")
    sys.exit(1)

fasta_file = sys.argv[1]
list_file = sys.argv[2]
output_file = sys.argv[3]

input_gzipped = fasta_file.endswith('.gz')
output_gzipped = output_file.endswith('.gz')

# Read the list of scaffolds to keep
with open(list_file, "r") as f:
    scaffolds_to_keep = {line.strip() for line in f}

# Filter the fasta file
with (gzip.open(fasta_file, "rt") if input_gzipped else open(fasta_file, "r")) as fasta_file, \
     (gzip.open(output_file, "wt") if output_gzipped else open(output_file, "w")) as output_f:
    for record in SeqIO.parse(fasta_file, "fasta"):
        if record.id in scaffolds_to_keep:
            SeqIO.write(record, output_f, "fasta")

print(f"Filtered fasta file saved as '{output_file}'")
