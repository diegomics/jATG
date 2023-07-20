# 1. Quick Stats
🧬⚡️🧬⚡️🧬⚡️🧬⚡️

This first analysis aims to generate a rapid overview of the genome assembly and produce outputs that come in handy posteriorly.

## Output:
```
[OUT_DIR]
└── jATG
    └── [SPECIES_NAME]
        └── [ASSEMBLY_ID]
            └── 1.stats
                ├── <..>_shortStats.tsv     # very brief stats of the assembly
                ├── full_fasta_header       # complete header of each scaffold
                ├── main_scaffolds          # list with scaffolds longer than 5 Mbp
                ├── number_lengths_GC_Ns    # table with name, length (decreasing order), GC rate, % of Ns of each scaffold
                ├── <..>_main_scaff.paf     # alignment between the main scaffolds of the assembly and a reference (if provided)
                ├── <..>.html               # interactive DotPlot between the assembly and a reference (if provided)
                ├── <..>.png                # png of the DotPlot between the assembly and a reference (if provided)
                ├── <..>_sexChrSeqs.faa     # sex chromosomes-linked genes sequences identified from a reference (if provided)
                ├── <..>_sexChrGenes.tsv    # sex chromosomes-linked genes IDs identified from a reference (if provided)
                ├── sexChr.paf              # alignment between sex-chromosome linked genes from reference (if provided) and the assembly
                └── ..

```

### How to run?

Requirements:
* [Slurm](https://slurm.schedmd.com)
* [Conda](https://docs.conda.io)


1) Edit `1.stats_variables.cnf` file with the respective paths, values and parameters.

2) Install needed software with: `bash 2.install_stats_dependencies.sh`

3) Run the masking pipeline in _Slurm_ with: `bash 3.Run_stats.sh`

\*) It uses up to 6 cpus and 18 Gb of RAM
