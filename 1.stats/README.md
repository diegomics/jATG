# 1. Quick overview
🧬⚡️🧬⚡️🧬⚡️🧬⚡️🧬⚡️🧬

This first analysis aims to generate a rapid overview of the genome assembly and produce outputs that come in handy posteriorly. You can provide a reference or close-related species for some analysis.

## Output:
```
[OUT_DIR]
└── jATG
    └── [SPECIES_NAME]
        └── [ASSEMBLY_ID]
            └── 1.overview
                ├── <..>_shortStats.md                     # very brief stats of the assembly
                ├── full_fasta_header                      # complete header of each scaffold
                ├── main_scaffolds                         # list with scaffolds longer than 5 Mbp
                ├── number_lengths_GC_Ns                   # table with name, length (decreasing order), GC rate, % of Ns of each scaffold
                ├── dotplot.<..>
                │   ├── <..>_main_scaff.paf                # alignment between the main scaffolds of the assembly and a reference (if provided)
                │   ├── <..>.html                          # interactive DotPlot between the assembly and a reference (if provided)
                │   └── <..>.png                           # png of the DotPlot between the assembly and a reference (if provided)
                ├── GC_Telo
                │   ├── ..
                │   ├── <..>_GC.tab                        # GC% across the assembly
                │   ├── <..>_telomeric_repeat_windows.tsv  # telomeric signal across the assembly
                │   ├── <..>_gaps.bed                      # position of the gaps across the assembly
                │   └── plots
                │       ├── COMBINED_GAPS_GC_TELO.svg      # plot showing GC%, telomeric signal and gaps in all chromosomes
                │       ├── <..>_GAPS_GC_TELO.svg          # plot showing GC%, telomeric signal and gaps in each chromosome
                │       └── ..
                └── sexChr.<..>
                    ├── <..>_sexChrSeqs.faa                # sex chromosomes-linked genes sequences identified from a reference (if provided)
                    ├── <..>_sexChrGenes.md                # table of sex chromosomes-linked genes IDs identified from a reference (if provided)
                    ├── sexChr.paf                         # alignment between sex-chromosome linked genes from reference (if provided) and the assembly
                    └── sexChr_evidence                    # list with number of hits for sex-chromosome linked genes between reference (if provided) and each scaffold
```

### How to run?

1) Edit `1.stats_variables.cnf` file with the respective paths, values and parameters.

2) Check if the provided reference of close-related species contains sex-chromosome relevant data: `bash 2.reference_check.sh`

3) Run the analysis based on the inputs provided: `bash 3.Run_stats.sh`

\*) It uses up to 6 cpus and 18 Gb of RAM


### About the analysis and setting of the parameters:
