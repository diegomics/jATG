import sys
import os
import gzip
from intervaltree import Interval, IntervalTree


def open_file(file_path, mode):
    _, file_extension = os.path.splitext(file_path)
    if file_extension == '.gz':
        return gzip.open(file_path, mode + 't')
    else:
        return open(file_path, mode)

# Check that correct number of arguments are passed
if len(sys.argv) != 4:
	print("""
	Usage: python vcf_masking.py <vcf_file_path> <bed_file_path> <output_file_path>
	input and output vcf file can also be non-gzipped
	""")
	sys.exit(1)

vcf_file_path = sys.argv[1]
bed_file_path = sys.argv[2]
output_file_path = sys.argv[3]


# Read the BED file into a dictionary of interval trees
trees = {}
with open(bed_file_path, 'r') as bed_file:
    for line in bed_file:
        chrom, start, end = line.split()
        # Adjust the BED intervals by 1 because the BED format is 0-based
        start = int(start) + 1
        end = int(end) + 1
        if chrom not in trees:
            trees[chrom] = IntervalTree()
        trees[chrom].add(Interval(start, end))

# Process the VCF file
with open_file(vcf_file_path, 'r') as vcf_file, open_file(output_file_path, 'w') as output_file:
    for line in vcf_file:
        # If the line is part of the header, write it to the output file unmodified
        if line.startswith('#'):
            output_file.write(line)
            continue

        line_parts = line.split()
        chrom = line_parts[0]
        pos = int(line_parts[1])

        # Modify the line if the position falls within any of the BED intervals
        if chrom in trees and trees[chrom][pos]:
            line_parts[4] = '.'
            line_parts[5] = '.'
            line_parts[6] = '.'
            line_parts[7] += ';MASKED'
            line_parts[8] = 'GT:AD:DP:RGQ'
            line_parts[9] = './.:0:0:0'

        # Write the (possibly modified) line to the output file
        output_file.write('\t'.join(line_parts) + '\n')
