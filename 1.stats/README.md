# 1. Quick Stats

This first analysis aims to generate a rapid overview of the genome assembly and produce outputs that come in handy posteriorly.

## Output:
```
[OUT_DIR]
└── jATG
    └── [SPECIES_NAME]
        └── [ASSEMBLY_ID]
            └── 1.stats
                ├── ..
                ├── <..>.HM.fa      # hard-masked genome   
                └── <..>.masked.fa  # soft-masked genome

```
The outputs are:
* b
* `full_fasta_header` contains the full name of all the scaffolds
* b
* b

creates a file with assembly stats named assembly_stats, a file with the full name of the scaffolds named full_fasta_header, a TSV file named number_lengths_GC_Ns showing in decreasing order the row number (to quick compare with N90 from the stats), name, length, GC content and Ns content of the scaffolds, and a file with a list with the names of the main scaffolds to maybe use in downstream analysis (larger than 5Mb).


### How to run?
